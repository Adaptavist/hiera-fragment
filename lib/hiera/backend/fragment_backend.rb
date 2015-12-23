# Copyright 2015 Adaptavist.com Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fileutils'
require 'yaml'
require 'set'
require 'pathname'

class Hiera
  module Backend
    class Fragment_backend
      def initialize
        Fragment_backend::debug 'Hiera fragment backend starting'
      end

      def lookup(key, scope, order_override, resolution_type)
        answer = nil
        case resolution_type
          when :array
            answer = []
          when :hash
            answer = {}
          end
        answer
      end

      SUPPORTED_EXTENSIONS = %w{yaml eyaml}

      def self.process_files
        conf = Config[:fragment]
        data_dir = conf[:datadir]
        # restrict to yaml extensions only

        if conf[:extensions] and not conf[:extensions].to_set.subset? SUPPORTED_EXTENSIONS.to_set
          raise "Unsupported extensions #{conf[:extensions]}. Only #{SUPPORTED_EXTENSIONS} are supported"
        end

        extensions = [conf[:extensions] || SUPPORTED_EXTENSIONS].flatten.join(',')

        fragments = [conf[:fragments]].flatten.map do |fragment|
          path_join_glob(data_dir, "#{fragment}.{#{extensions}}")
        end.flatten.select do |file|
          File.file? file
        end

        if fragments.empty?
          warn "No fragments found in #{data_dir}"
        end

        dest_dir = conf[:destdir] || Config[:yaml][:datadir]

        input_dirs = [conf[:inputdirs]].flatten.map { |file| Pathname.new(file).realpath.to_s }

        debug "Cleaning output dir: #{dest_dir}"
        FileUtils.rm_rf dest_dir
        FileUtils.mkdir_p dest_dir

        glob_pattern = "**/*.{#{extensions}}"
        debug "Using fragments #{fragments.join(',')}"
        merge_input(fragments, glob_pattern, input_dirs) do |yaml_file, input_dir, yaml|
          output_file = Pathname.new(yaml_file).realpath.to_s.sub(input_dir, dest_dir)
          debug "Writing to #{output_file}"

          FileUtils.mkdir_p File.dirname(output_file)
          File.open(output_file, 'w+') { |file| YAML.dump(yaml, file) }
        end
      end

      private

      def self.debug(message)
        Hiera.debug("[fragment_backend]: #{message}")
      end

      def self.warn(message)
        Hiera.warn("[fragment_backend]: #{message}")
      end

      def self.path_join_glob(dir, file_pattern)
        Dir.glob(File.join(dir, file_pattern))
      end

      def self.merge_input(fragments, glob_pattern, input_dirs, &f)
        input_dirs.each do |input_dir|
          debug "Searching for files in #{input_dir} using pattern #{glob_pattern}"
          path_join_glob(input_dir, glob_pattern).each do |yaml_file|
            debug "Processing #{yaml_file}"

            yaml = merge_files(yaml_file, fragments)
            f.call(yaml_file, input_dir, yaml)
          end
        end
      end

      def self.replace_values(target, source)
        if source.nil? or target.nil? or not source.is_a?(Hash) or not target.is_a?(Hash)
          return
        end
        keys = source.keys.to_set
        target.select {|key,value| keys.include? key}.each do |key, val|
          if val.is_a?(Hash) and not val.empty?
            replace_values val, source[key]
          else
            target[key] = source[key]
          end
        end
      end

      def self.merge_files(base, overrides = [])
        result = YAML.load_file(base)
        if result.nil? or not result.is_a?(Hash)
          return
        end
        keys = result.keys.to_set
        [overrides].flatten.select {|file| File.readable? file}.each do |override_file|
          override = YAML.load_file(override_file)
          replace_values result, override
        end
        result
      end
    end
  end
end

Hiera::Backend::Fragment_backend.process_files
