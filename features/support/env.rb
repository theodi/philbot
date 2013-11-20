require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start

require 'coveralls'
Coveralls.wear!

require 'aruba/cucumber'

$: << File.expand_path('../../lib', File.dirname(__FILE__))
require 'philbot'

require 'cucumber/rspec/doubles'

require 'resque/mock'
Resque.mock!

def aruba_tmp
  File.join %w{tmp aruba}
end

def full_path filename
  File.expand_path File.join aruba_tmp, filename
end