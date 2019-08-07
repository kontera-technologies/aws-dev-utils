module AwsDevUtils
  class RetryWrapper

    # Initialize a new RetryWrapper, internal use only
    # @params client [Aws client, NextTokenWrapper, RetryWrapper]
    # @param max_tries [Integer] - max number of retries
    def initialize client, max_tries=5
      @client = client
      @max_tries = max_tries
    end

    def method_missing m, *args, &block
      do_call(m,*args,&block)
    end

    private

    def do_call m, *args, &block
      r = e = nil
      tries = 0
      while (r.nil? && tries < @max_tries) do
        begin
          r = @client.send(m, *args, &block)
        rescue Exception => e
          tries += 1
          sleep 2**tries + rand
        end
      end

      raise e unless e.nil? || r

      return r
    end

  end
end
