APPLICATION_ROOT = File.expand_path(File.join(__FILE__, '..', '..'))
$LOAD_PATH.push(APPLICATION_ROOT + '/lib')

require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'bundler/setup'
Bundler.setup

RSpec.configure do |config|
  # some (optional) config here
end
