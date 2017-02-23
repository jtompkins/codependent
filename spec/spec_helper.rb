APPLICATION_ROOT = File.expand_path(File.join(__FILE__, '..', '..'))
$LOAD_PATH.push(APPLICATION_ROOT + '/lib')

require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/spec/resolvers"
  add_filter "/spec/validators"
end

require 'bundler/setup'
Bundler.setup

RSpec.configure do |config|
  config.filter_run_when_matching :focus
end
