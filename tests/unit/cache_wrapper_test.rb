require_relative '../minitest_helper'
require 'ostruct'
require 'aws-sdk-core'
require 'deepsort'

module AwsDevUtils

  class CacheWrapperTester < TestCase

    def setup
      cache.backend = Backend::Memory.new
    end

    def teardown
      cache.backend = nil
    end

    def test_with_cache_set_value_without_args
      client = client_setup
      value = {res: 'test-value-from-cache'}
      cache.set([:mock_func, {}, 60], value, 60)
      assert_equal value, client.mock_func
      assert_equal value, cache.get([:mock_func, {}, 60])
    end

    def test_with_cache_set_value_with_args
      client = client_setup
      value = {res: 'test-value-from-cache'}
      cache.set([:mock_func, {filters: [{name: 'filter1', value: ['val1', 'val2']}]}, 60], value, 60)
      assert_equal value, client.mock_func({filters: [{name: 'filter1', value: ['val1', 'val2']}]})
      assert_equal value, cache.get([:mock_func, {filters: [{name: 'filter1', value: ['val1', 'val2']}]}, 60])
    end

    def test_with_cache_new_value_without_args
      client = client_setup
      value = {res: 'test-new-value'}
      assert_equal value, client.mock_func
      assert_equal value, cache.get([:mock_func, {}, 60])
    end

    def test_with_cache_new_value_with_args
      client = client_setup
      value = {res: 'test-new-value'}
      assert_equal value, client.mock_func({filters: [{name: 'filter1', value: ['val1', 'val2']}]})
      assert_equal value, cache.get([:mock_func, {filters: [{name: 'filter1', value: ['val1', 'val2']}]}, 60])
    end

    def test_sort_filters
      client = client_setup
      value = {res: 'test-value-from-cache'}
      filters = {filters: [{name: 'filter2', value: ['val1', 'val2']}, {name: 'filter1', value: ['val2', 'val1']}]}
      cache.set([:mock_func, filters.deep_sort, 60], value, 60)
      assert_equal value, client.mock_func(filters)
      assert_equal value, cache.get([:mock_func, filters.deep_sort, 60])
      assert_nil cache.get([:mock_func, filters, 60])
    end

    def cache
      Cache.instance
    end

    def client_setup
      CacheWrapper.new MockClient.new
    end

    class MockClient
      def mock_func *args
        OpenStruct.new(res: 'test-new-value')
      end
    end

  end
end
