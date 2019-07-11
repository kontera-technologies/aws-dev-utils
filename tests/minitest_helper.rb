require 'simplecov'
SimpleCov.start do
  add_filter "/tests/"
end

$:.unshift File.expand_path("../../lib",__FILE__)
require 'aws-dev-utils'
require 'minitest'
require 'minitest/autorun'

if ENV['CODECOV_TOKEN']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

module AwsDevUtils
  class TestCase < Minitest::Test
  end

  class MethodCallCounterWrapper
    attr_accessor :counters

    def initialize client
      @client = client
      self.counters = {}
    end

    def method_missing m, *args, &block
      self.counters[m] = 1 + (self.counters[m] || 0)
      @client.send(m , *args, &block)
    end
  end
end
