require 'rubocop/rake_task'

RuboCop::RakeTask.new

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task ci: [:spec, :rubocop]
