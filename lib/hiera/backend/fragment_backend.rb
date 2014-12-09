require 'hiera/preprocess'
require 'fileutils'

class Hiera
  module Backend
    class Fragment_backend
      def initialize
        Fragment_backend::debug "Hiera fragment backend starting"
      end

      def lookup(key, scope, order_override, resolution_type)
        nil
      end

      def self.process_files
        conf = Config[:fragment]
        data_dir = conf[:datadir]
        extensions = [conf[:extensions] || %w{yaml eyaml}].flatten
        fragments = [conf[:fragments]].flatten.flat_map do |fragment|
          path_join_glob(data_dir, "#{fragment}.{#{extensions.join(',')}}")
        end
        dest_dir = File.absolute_path(conf[:destdir] || Config[:yaml][:datadir])
        input_dirs = [conf[:inputdirs]].flatten.map { |file| File.absolute_path(file) }

        debug "Cleaning output dir: #{dest_dir}"
        FileUtils.rm_rf dest_dir

        glob_pattern = "**/*.{#{extensions.join(',')}}"
        debug "Using fragments #{fragments.join(',')}"
        merge_input(fragments, glob_pattern, input_dirs) do |yaml_file, input_dir, yaml|
          output_file = File.absolute_path(yaml_file).sub(input_dir, dest_dir)
          debug "Writing to #{output_file}"

          FileUtils.mkpath File.dirname(output_file)
          File.open(output_file, 'w+') { |file| YAML.dump(yaml, file) }
        end
      end

      private

      def self.debug(message)
        Hiera.debug("[fragment_backend]: #{message}")
      end

      def self.path_join_glob(dir, file_pattern)
        Dir.glob(File.join(dir, file_pattern))
      end

      def self.merge_input(fragments, glob_pattern, input_dirs)
        fragment = HieraFragment.new
        input_dirs.each do |input_dir|
          debug "Searching for files in #{input_dir} using pattern #{glob_pattern}"
          path_join_glob(input_dir, glob_pattern).each do |yaml_file|
            debug "Processing #{yaml_file}"

            yaml = fragment.merge_files(yaml_file, fragments)
            yield yaml_file, input_dir, yaml
          end
        end
      end
    end
  end
end

Hiera::Backend::Fragment_backend.process_files
