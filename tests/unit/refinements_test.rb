require_relative '../minitest_helper'
require 'ostruct'
require 'aws-sdk-core'

using AwsDevUtils::Refinements

module AwsDevUtils
  class RefinementsTester < TestCase

    def test_retry_wrapper
      client = Aws::STS::Client.new
      assert_instance_of ClientWrapper, client.with_retry
    end

    def test_next_token_wrapper
      client = Aws::STS::Client.new
      assert_instance_of ClientWrapper, client.with_next_token
    end

    def test_cache_wrapper
      client = Aws::STS::Client.new
      assert_instance_of ClientWrapper, client.with_cache
    end

    def test_cache_wrapper
      client = Aws::STS::Client.new
      assert_instance_of ClientWrapper, client.with_cache
    end

  end
end
