require 'redis'

module AwsDevUtils
  module Backend
    class Redis
      # :nocov:
      def initialize url='redis://localhost:6379'
        @redis = ::Redis.new(url: url)
      end

      def get key
        @redis.get key
      end

      def set key, value, exp
        @redis.setex key, exp, value
      end
    end
  end
end
