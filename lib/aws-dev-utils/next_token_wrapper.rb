module AwsDevUtils
  class NextTokenWrapper

    # Initialize a new NextTokenWrapper, internal use only
    # @params client [Aws client / NextTokenWrapper / RetryWrapper]
    # @param max [Integer] - max number of requests
    def initialize client, max=100
      @client = client
      @max = max
    end

    def method_missing m, *args, &block
      do_call(m,*args,&block)
    end

    private
    #todo: add a condition for the route53 case and refactor var names
    #irb -I lib of dev-utils
    def do_call m, *args, &block
      @client.send(m , *args, &block).to_h.tap do |r|
        i = 1
        if r[:is_truncated] && r[:next_record_name]
          while(r[:is_truncated].eql? true && i < @max) do
            i += 1
            res = @client.send(m, (args[0]||{}).merge(key2 => r[key])).to_h
            res.each { |k,v| r[k] = v.is_a?(Array) ? r[k].concat(v) : v }
            r.delete_if {|k,v| !res.keys.include?(k) }
          end
        else
          key, key2 = extract_keys r #resp
          # resp_key = key
          # req_key = key2
          while(key && r[key] && i < @max) do
            i += 1
            res = @client.send(m, (args[0]||{}).merge(key2 => r[key])).to_h
            res.each { |k,v| r[k] = v.is_a?(Array) ? r[k].concat(v) : v }
            r.delete_if {|k,v| !res.keys.include?(k) }
          end
          r.delete key
        end
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








a = ["audience-profiler-svc-ui", "herodotus-api", "abi-mgmt", "first-party-uploader", "abi-realtime", "kw-suggest", "twitter-api", "abi-content-search"]
a.map {}
  next_name = "internal.aws.kontera.com."
  next_type = "NS"
  records = []
  loop {
    response = route53_client.list_resource_record_sets(
      hosted_zone_id: "/hostedzone/Z15D6GJDGY0YD8",
      start_record_name: next_name,
      start_record_type: next_type,
    )

    records.push(response.resource_record_sets)
    break unless response.is_truncated

    next_name = response.next_record_name
    next_type = response.next_record_type

  }
  records.flatten.
