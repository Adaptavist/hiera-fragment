require 'yaml'
require 'deep_merge'
class HieraFragment
  def self.merge_files(base, overrides = [])
    result = YAML.load_file(base)
    [overrides].flatten.select {|file| File.readable? file}.each do |override_file|
      override = YAML.load_file(override_file)
      result.deep_merge!(override, {:knockout_prefix => '--'})
    end
    result
  end
end
