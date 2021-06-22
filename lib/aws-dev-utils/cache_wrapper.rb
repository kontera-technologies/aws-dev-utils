require 'deepsort'

module AwsDevUtils
  class CacheWrapper
    include AwsDevUtils::Utils

  # Initialize a new CacheWrapper, internal use only.
  # @param client [Aws client, NextTokenWrapper, RetryWrapper]
  # @param exp [Integer] - the key-value timeout
  def initialize client, exp=60, client_name: nil
      @client = client
      @exp = exp
      @client_name = client_name || client.class.name
    end

    def method_missing m, *args, &block
      do_call(m, args.first || {})
    end

    private

    def cache_key m, params
      [@client_name, m, params.deep_sort, @exp]
    end

    def do_call m, params
      Cache.instance.fetch(cache_key(m, params), @exp) {
        nested_hash(@client.send(m, params))
      }
    end

  end
end
