require_relative '../minitest_helper'
require 'ostruct'
require 'aws-sdk-core'

module AwsDevUtils

  class ClientWrapperTester < TestCase
    using AwsDevUtils::Refinements

    def test_with_cache
      client = Aws::STS::Client.new
      a = client.with_cache
      assert_instance_of ClientWrapper, a
      assert a.send(:cache?)
      assert !a.send(:retry?)
      assert !a.send(:next_token?)
    end

    def test_with_retry
      client = Aws::STS::Client.new
      a = client.with_retry
      assert_instance_of ClientWrapper, a
      assert a.send(:retry?)
      assert !a.send(:cache?)
      assert !a.send(:next_token?)
    end

    def test_with_next_token
      client = Aws::STS::Client.new
      a = client.with_next_token
      assert_instance_of ClientWrapper, a
      assert a.send(:next_token?)
      assert !a.send(:cache?)
      assert !a.send(:retry?)
    end

    def test_with_cache_with_retry
      client = Aws::STS::Client.new
      a = client.with_cache.with_retry
      assert_instance_of ClientWrapper, a
      assert a.send(:cache?)
      assert a.send(:retry?)
      assert !a.send(:next_token?)
    end

    def test_with_cache_with_next_token
      client = Aws::STS::Client.new
      a = client.with_cache.with_next_token
      assert_instance_of ClientWrapper, a
      assert a.send(:cache?)
      assert a.send(:next_token?)
      assert !a.send(:retry?)
    end

    def test_with_retry_with_next_token
      client = Aws::STS::Client.new
      a = client.with_retry.with_next_token
      assert_instance_of ClientWrapper, a
      assert a.send(:next_token?)
      assert a.send(:retry?)
      assert !a.send(:cache?)
    end

    def test_with_retry_with_next_token_with_cache
      client = Aws::STS::Client.new
      a = client.with_retry.with_next_token.with_cache
      assert_instance_of ClientWrapper, a
      assert a.send(:next_token?)
      assert a.send(:retry?)
      assert a.send(:cache?)
    end

    def test_with_cache_run_the_client_method
      client = ClientWrapper.new(MockClient.new)
      cache.backend = Backend::Memory.new
      assert_equal OpenStruct.new(res: 'test-value'), client.with_cache.mock_func
      cache.backend = nil
    end

    def test_with_retry_run_the_client_method
      client = ClientWrapper.new(MockClient.new)
      assert_equal OpenStruct.new(res: 'test-value'), client.with_retry.mock_func
    end

    def test_with_next_token_run_the_client_method
      client = ClientWrapper.new(MockClient.new)
      assert_equal OpenStruct.new(res: 'test-value'), client.with_next_token.mock_func
    end

    def test_with_cache_with_retry_run_the_client_method
      client = ClientWrapper.new(MockClient.new)
      cache.backend = Backend::Memory.new
      assert_equal OpenStruct.new(res: 'test-value'), client.with_cache.with_retry.mock_func
      cache.backend = nil
    end

    def test_with_cache_with_next_token_run_the_client_method
      client = ClientWrapper.new(MockClient.new)
      cache.backend = Backend::Memory.new
      assert_equal OpenStruct.new(res: 'test-value'), client.with_cache.with_next_token.mock_func
      cache.backend = nil
    end

    def test_with_retry_with_next_token_run_the_client_method
      client = ClientWrapper.new(MockClient.new)
      assert_equal OpenStruct.new(res: 'test-value'), client.with_retry.with_next_token.mock_func
    end

    def test_with_cache_with_retry_with_next_token_run_the_client_method
      client = ClientWrapper.new(MockClient.new)
      cache.backend = Backend::Memory.new
      assert_equal OpenStruct.new(res: 'test-value'), client.with_cache.with_retry.with_next_token.mock_func
      cache.backend = nil
    end

    def cache
      Cache.instance
    end

    class MockClient
      def mock_func *args
        OpenStruct.new(res: 'test-value')
      end
    end

  end
end
