module AwsDevUtils
  class NextTokenWrapper

    # Initialize a new NextTokenWrapper
    # @params client - Aws client / CacheWrapper / RetryWrapper
    # @param [Integer] max - max number of requests
    def initialize client, max=100 #:nodoc:
      @client = client
      @max = max
    end

    def method_missing m, *args, &block
      do_call(m,*args,&block)
    end

    private

    def do_call m, *args, &block
      @client.send(m , *args, &block).to_h.tap do |r|
        i = 1
        key, key2 = extract_keys r
        while(key && r[key] && i < @max) do
          i += 1
          res = @client.send(m, (args[0]||{}).merge(key2 => r[key])).to_h
          res.each { |k,v| r[k] = v.is_a?(Array) ? r[k].concat(v) : v }
          r.delete_if {|k,v| !res.keys.include?(k) }
        end
        r.delete key
      end
    end

    def extract_keys x
      case
      when x[:next_token]
        [:next_token, :next_token]
      when x[:next_marker]
        [:next_marker, :marker]
      when x[:next_continuation_token]
        [:next_continuation_token, :continuation_token]
      else nil
      end
    end

  end
end
