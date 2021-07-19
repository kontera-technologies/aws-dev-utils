require_relative '../minitest_helper'
require 'ostruct'

module AwsDevUtils

  class NextTokenWrapperTester < TestCase

    def test_no_value_with_token
      client = client_setup

      assert_equal({vals: nil}, client.mock_next_token)
      assert_equal 1, client.counters[:mock_next_token]
    end

    def test_no_value_with_marker
      client = client_setup

      assert_equal({vals: nil}, client.mock_next_marker)
      assert_equal 1, client.counters[:mock_next_marker]
    end

    def test_no_value_with_continuation_token
      client = client_setup

      assert_equal({vals: nil}, client.mock_next_continuation_token)
      assert_equal 1, client.counters[:mock_next_continuation_token]
    end

    def test_no_value_with_record_name
      client = client_setup

      assert_equal({vals: nil}, client.mock_next_record_name)
      assert_equal 1, client.counters[:mock_next_record_name]
    end

    def test_single_with_token
      client = client_setup [(0..20).to_a]

      assert_equal({vals: (0..20).to_a}, client.mock_next_token)
      assert_equal 1, client.counters[:mock_next_token]
    end

    def test_single_with_marker
      client = client_setup [(0..20).to_a]

      assert_equal({vals: (0..20).to_a}, client.mock_next_marker)
      assert_equal 1, client.counters[:mock_next_marker]
    end

    def test_single_with_continuation_token
      client = client_setup [(0..20).to_a]

      assert_equal({vals: (0..20).to_a}, client.mock_next_continuation_token)
      assert_equal 1, client.counters[:mock_next_continuation_token]
    end

    def test_single_with_record_name
      client = client_setup [(0..20).to_a]

      assert_equal({vals: (0..20).to_a}, client.mock_next_record_name)
      assert_equal 1, client.counters[:mock_next_record_name]
    end

    def test_multi_with_token
      client = client_setup [0..5,6..10,11..20].map &:to_a

      assert_equal({vals: (0..20).to_a}, client.mock_next_token)
      assert_equal 3, client.counters[:mock_next_token]
    end

    def test_multi_with_marker
      client = client_setup [0..5,6..10,11..20].map &:to_a

      assert_equal({vals: (0..20).to_a}, client.mock_next_marker)
      assert_equal 3, client.counters[:mock_next_marker]
    end

    def test_multi_with_continuation_token
      client = client_setup [0..5,6..10,11..20].map &:to_a

      assert_equal({vals: (0..20).to_a}, client.mock_next_continuation_token)
      assert_equal 3, client.counters[:mock_next_continuation_token]
    end

    def test_multi_with_record_name
      client = client_setup [0..5,6..10,11..20].map &:to_a

      assert_equal({vals: (0..20).to_a}, client.mock_next_record_name)
      assert_equal 3, client.counters[:mock_next_record_name]
    end

    def test_max_with_token
      client = client_setup [0..5,6..10,11..20].map(&:to_a), 2

      assert_equal({vals: (0..10).to_a}, client.mock_next_token)
      assert_equal 2, client.counters[:mock_next_token]
    end

    def test_max_with_marker
      client = client_setup [0..5,6..10,11..20].map(&:to_a), 2

      assert_equal({vals: (0..10).to_a}, client.mock_next_marker)
      assert_equal 2, client.counters[:mock_next_marker]
    end

    def test_max_with_continuation_token
      client = client_setup [0..5,6..10,11..20].map(&:to_a), 2
      assert_equal({vals: (0..10).to_a}, client.mock_next_continuation_token)
      assert_equal 2, client.counters[:mock_next_continuation_token]
    end

    def test_max_with_record_name
      client = client_setup [0..5,6..10,11..20].map(&:to_a), 2
      assert_equal({vals: (0..10).to_a}, client.mock_next_record_name)
      assert_equal 2, client.counters[:mock_next_record_name]
    end

    def client_setup vals=[], max=nil
      if max.nil?
        NextTokenWrapper.new MethodCallCounterWrapper.new(MockClient.new vals)
      else
        NextTokenWrapper.new MethodCallCounterWrapper.new(MockClient.new vals), max
      end
    end

    class MockClient
      def initialize vals
        @vals = vals
      end

      def get_next_value req_keys, next_req_keys
        req_keys = req_keys.map {|resp_key| resp_key || 0}.first if req_keys.uniq.size.eql? 1
        obj = {vals: @vals[req_keys]}
        next_req_keys.each { |next_req_keys| obj[next_req_keys] = req_keys+1 if (req_keys+1) < @vals.length }
        return obj
      end

      def mock_next_token props={}
        get_next_value [props[:next_token]], [:next_token]
      end

      def mock_next_marker props={}
        get_next_value [props[:marker]], [:next_marker]
      end

      def mock_next_continuation_token props={}
        get_next_value [props[:continuation_token]], [:next_continuation_token]
      end

      def mock_next_record_name props={}
        get_next_value [props[:start_record_type], props[:start_record_name]], [:next_record_type, :next_record_name]
      end
    end
  end
end
