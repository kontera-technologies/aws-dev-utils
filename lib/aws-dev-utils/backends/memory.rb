module AwsDevUtils
  module Backend
    class Memory

      def initialize
        @hash = {}
      end

      # Get the value of key, if not found, returns nil.
      def get key
        clean_cache!
        @hash[key][1]
      end

      # Set key to hold the value and set key to timeout after the a given expiration time(in seconds).
      # @param key [Object]
      # @param value [Object]
      # @param exp [Integer]  - the key-value timeout
      def set key, value, exp
        clean_cache!
        @hash[key] = [Time.now + exp, value]
      end

      private

      def clean_cache!
        @hash = @hash.each_with_object({}) do |(k, (exp, v)), acc|
          acc[k] = [exp, v] if Time.now < exp
        end
      end
    end
  end
end
