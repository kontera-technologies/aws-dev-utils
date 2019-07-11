require_relative '../minitest_helper'
require 'ostruct'

module AwsDevUtils

  class RetryWrapperTester < TestCase
    def test_no_retry
      client = client_setup 0
      assert_equal :mock_value, client.mock_func
      assert_equal 1, client.counters[:mock_func]
    end

    def test_successful_retry_with_default_max
      client = client_setup 1
      assert_equal :mock_value, client.mock_func
      assert_equal 2, client.counters[:mock_func]
    end

    def test_successful_retry_with_custom_max
      client = client_setup 1,3
      assert_equal :mock_value, client.mock_func
      assert_equal 2, client.counters[:mock_func]
    end

    def test_failed_retry_with_custom_max
      client = client_setup 3,1
      assert_raises {client.mock_func}
      assert_equal 1, client.counters[:mock_func]
    end

    def client_setup num_of_errors, max_tries=nil
      if max_tries.nil?
        AwsDevUtils::RetryWrapper.new AwsDevUtils::MethodCallCounterWrapper.new(MockClient.new num_of_errors)
      else
        AwsDevUtils::RetryWrapper.new AwsDevUtils::MethodCallCounterWrapper.new(MockClient.new num_of_errors), max_tries
      end
    end

    class MockClient
      def initialize num_of_errors
        @num_of_errors = num_of_errors
      end

      def mock_func
        if @num_of_errors > 0
          @num_of_errors = @num_of_errors - 1
          raise "Mock Error"
        else
          :mock_value
        end
      end
    end
  end
end
