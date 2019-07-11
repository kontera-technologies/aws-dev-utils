require_relative '../minitest_helper'
require 'ostruct'

module AwsDevUtils

  class UtilsTester < TestCase
    include AwsDevUtils::Utils

    def test_nested_struct_no_argument
      assert_raises(ArgumentError) {nested_struct}
    end

    def test_nested_struct_empty_hash
      h  = {}
      s  = OpenStruct.new
      assert_equal s, nested_struct(h)
    end

    def test_nested_struct_regular_hash
      nested_struct(a: 1, b: 2, c: 3).tap do |obj|
        assert_equal obj.a, 1
        assert_equal obj.b, 2
        assert_equal obj.c, 3
      end
    end

    def test_nested_struct_with_nested_hash
      nested_struct(a: [{x: 1},{y: 2, z:[{r: 4, t:5}]},{w: 3}], b: 6).tap do |obj|
        assert_equal obj.a.first.x, 1
        assert_equal obj.a[1].y, 2
        assert_equal obj.a[1].z.first.r, 4
        assert_equal obj.a[1].z.first.t, 5
        assert_equal obj.a[2].w, 3
        assert_equal obj.b, 6
      end
    end

    def test_nested_struct_with_strings
      nested_struct(a: [{y: 2, z:["foo", "bar"]}]).tap do |obj|
        assert_equal obj.a.first.y, 2
        assert_equal obj.a.first.z[0], "foo"
        assert_equal obj.a.first.z[1], "bar"
      end
    end

    def test_nested_struct_tap_values
      h = {a: 1,b: 2, c: 3}
      assert_equal h.values, nested_struct(h).values
    end

    def test_nested_hash_no_argument
      assert_raises(ArgumentError) {nested_hash}
    end

    def test_nested_hash_empty_hash
      h  = {}
      s  = OpenStruct.new
      assert_equal h, nested_hash(s)
    end

    def test_nested_hash_regular_object
      nested_hash(OpenStruct.new(a: 1, b: 2, c: 3)).tap do |obj|
        assert_equal obj[:a], 1
        assert_equal obj[:b], 2
        assert_equal obj[:c], 3
      end
    end

    def test_nested_hash_with_nested_struct
      nested_hash(OpenStruct.new(a: [OpenStruct.new(x: 1),OpenStruct.new(y: 2, z:[{r: 4, t:5}]),OpenStruct.new(w: 3)], b: 6)).tap do |obj|
        assert_equal obj[:a].first[:x], 1
        assert_equal obj[:a][1][:y], 2
        assert_equal obj[:a][1][:z].first[:r], 4
        assert_equal obj[:a][1][:z].first[:t], 5
        assert_equal obj[:a][2][:w], 3
        assert_equal obj[:b], 6
      end
    end

    def test_nested_hash_with_strings
      nested_hash(OpenStruct.new(a: [{y: 2, z:["foo", "bar"]}])).tap do |obj|
        assert_equal obj[:a].first[:y], 2
        assert_equal obj[:a].first[:z][0], "foo"
        assert_equal obj[:a].first[:z][1], "bar"
      end
    end

  end
end
