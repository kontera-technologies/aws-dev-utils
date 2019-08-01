require 'redis'

module AwsDevUtils
  module Backend
    class Redis
      # :nocov:
      # Initialize a new redis client
      # @params [String] url - specify redis url connection
      def initialize url='redis://localhost:6379'
        @redis = ::Redis.new(url: url)
      end

      # Get the value of key. If not found, returns nil
      def get key
        @redis.get key
      end

      # Set key to hold the value and set key to timeout after the a given expiration time(in seconds).
      # @param [Object] key
      # @param [Object] value
      # @param [Integer] exp - the key-value timeout
      def set key, value, exp
        @redis.setex key, exp, value
      end
    end
  end
end
