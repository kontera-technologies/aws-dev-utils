module AwsDevUtils
  module Backend
    class Memory

      def initialize
        @hash = {}
      end

      def get key
        clean_cache!
        @hash[key][1]
      end

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
