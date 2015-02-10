require 'bundler/gem_tasks'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "--tag ~standalone --tag standard"
  end

  RSpec::Core::RakeTask.new(:spec_standalone) do |t|
    t.rspec_opts = "--tag standalone --tag ~standard"
  end

  task :default => :spec
rescue LoadError
  # no rspec available
end

begin
  require 'ruby-lint/rake_task'

  RubyLint::RakeTask.new do |task|
    task.name  = 'lint'
    task.files = Dir.glob('lib/**/*.rb')
  end
rescue LoadError
  # no ruby-lint available
end
