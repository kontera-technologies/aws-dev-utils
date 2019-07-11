require 'aws-sdk-core'

module AwsDevUtils
  module Refinements

    refine Seahorse::Client::Base do
      def with_next_token *args
        AwsDevUtils::ClientWrapper.new(self).yield_self { |c| c.send(__callee__, *args) }
      end
      alias_method :with_retry, :with_next_token
      alias_method :with_cache, :with_next_token
    end

  end
end
