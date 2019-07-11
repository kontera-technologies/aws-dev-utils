require_relative '../minitest_helper'
require 'ostruct'

module AwsDevUtils
  class CacheTester < TestCase

    def test_serialize_deserialize
      r = OpenStruct.new(a: 1,b: 2, c: 3)
      s = cache.send(:deserialize, cache.send(:serialize, r))
      assert_equal r,s
    end

    def test_serialize_throw_exceptions
      assert_raises(TypeError) { cache.send(:serialize, proc{}) }
    end

    def test_deserialize_throw_exceptions
      assert_raises(TypeError) { cache.send(:deserialize, proc{}) }
    end

    def test_get_shouldnot_throw_exception
      cache.send(:get,proc{})
    end

    def test_set_shouldnot_throw_exception
      cache.send(:set,:k,proc{},1)
    end

    def test_fetch_should_run_block
      a = false
      cache.fetch(nil, 0) {a = true}
      assert a
    end

    private

    def cache
      Cache.instance
    end

  end
end
