module AwsDevUtils
  class ClientWrapper
    include AwsDevUtils::Utils

    def initialize client, options={}
      @client = client
      @options = options
    end

    def with_next_token max=100
      self.class.new(@client, @options.merge(next_token: max))
    end

    def with_retry max=5
      self.class.new(@client, @options.merge(retry: max))
    end

    def with_cache exp=60
      self.class.new(@client, @options.merge(cache: exp))
    end

    def method_missing m, *args, &block
      @client = RetryWrapper.new(@client, @options[:retry]) if retry?
      @client = NextTokenWrapper.new(@client, @options[:next_token]) if next_token?
      @client = CacheWrapper.new(@client, @options[:cache], client_name: @client.class.name) if cache?

      nested_struct(@client.send(m, *args, &block))
    end

    private

    def cache?
      @options[:cache]
    end

    def retry?
      @options[:retry]
    end

    def next_token?
      @options[:next_token]
    end

  end
end
