require 'deepsort'

module AwsDevUtils
  class CacheWrapper
    include AwsDevUtils::Utils

    # Initialize a new CacheWrapper, internal use only.
    # @param client [Aws client, NextTokenWrapper, RetryWrapper]
    # @param exp [Integer] - the key-value timeout
    def initialize client, exp=60
      @client = client
      @exp = exp
    end

    def method_missing m, *args, &block
      do_call(m, args.first || {})
    end

    private

    def do_call m, args
      Cache.instance.fetch([m, args.deep_sort, @exp], @exp) {
        nested_hash(@client.send(m, args))
      }
    end

  end
end
