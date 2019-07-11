module AwsDevUtils
  autoload :Refinements, "aws-dev-utils/refinements"
  autoload :NextTokenWrapper, "aws-dev-utils/next_token_wrapper"
  autoload :ClientWrapper, "aws-dev-utils/client_wrapper"
  autoload :RetryWrapper, "aws-dev-utils/retry_wrapper"
  autoload :CacheWrapper, "aws-dev-utils/cache_wrapper"
  autoload :MachineData, "aws-dev-utils/machine_data"
  autoload :Cache, "aws-dev-utils/cache"
  autoload :Utils, "aws-dev-utils/utils"
  module Backend
    autoload :Memory, 'aws-dev-utils/backends/memory'
    autoload :Redis, 'aws-dev-utils/backends/redis'
  end
end
