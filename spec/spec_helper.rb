$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'rubygems'
require 'rspec'
require 'rspec/autorun'

require 'rails/generators'
require 'jquery_corpus'

Rspec.configure do |config|
  config.mock_framework = :rspec
  #config.include Rspec::Matchers
  #config.mock_with :rspec
end
