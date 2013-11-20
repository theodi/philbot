require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start

require 'aruba/cucumber'

$: << File.expand_path("../../lib", File.dirname(__FILE__))
require 'philbot'

require 'cucumber/rspec/doubles'

require 'resque/mock'
Resque.mock!