# AWS Dev Utilities [![Build Status](https://travis-ci.org/kontera-technologies/aws-dev-utils.svg?branch=master)](https://travis-ci.org/kontera-technologies/aws-dev-utils) [![codecov](https://codecov.io/gh/kontera-technologies/aws-dev-utils/branch/master/graph/badge.svg)](https://codecov.io/gh/kontera-technologies/aws-dev-utils)

This library provides common ruby utilities to working with AWS SDK. It simplifies the work by reducing common boilerplates such as "next_token" pagination and "retry".
It provides a general API Wrapper with Redis based caching, paging and retry functionalities.

## Installation
AWS Dev Utilities is available from RubyGems.  

### Option 1: Via Bundler
Add the following to your application's Gemfile:
```ruby
gem 'aws-dev-utils', '~> 1.4'
```
And then execute:
```
$ bundle install
```
### Option 2: Via `gem install`
Execute the following inside your application directory:
```
$ gem install aws-dev-utils -v '~> 1.4'
```
## Usage
Add the following at the top of each Ruby script, or in each module/class you want to use the `with_next_token`, `with_cache` or `with_retry` functions:
```ruby
require 'aws-dev-utils'
using AwsDevUtils::Refinements
```

### with_next_token
Many AWS operations limit the number of results returned with each response. To make it easy to get the next page of results, every AWS response object is enumerable.  
This functionality is rarely needed and causes a lot of boilerplate code.  
Using the `client.with_next_token` the paged results will be collected for you.
The AWS client function and its results will be concatenated until either no more results are available or the max number of requests is reached.  
_`with_next_token` works with APIs that use `next_token`, `next_marker`, `next_continuation_token` or `next_record_name`._

```ruby
require 'aws-dev-utils'
using AwsDevUtils::Refinements

ec2_client = Aws::EC2::Client.new
# To get the full set of results:
ec2_client.
  with_next_token.
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])

# To get up to 5 pages of results:
ec2_client.
  with_next_token(5).
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])
```

### with_cache
In many cases a cache is required due to many processes or different machines querying the AWS api for data.  
By using the `client.with_cache`, the client functions results will be stored in cache.  
The default cache is a simple in memory *time based* store - `AwsDevUtils::Backend::Memory`.  
Incase in-memory cache is not a good solution then there is  also `Redis` based caching (`AwsDevUtils::Backend::Redis`).  
To use it, start a Redis instance and set it as the global cache backend:
```ruby
AwsDevUtils::Cache.instance.backend = AwsDevUtils::Backend::Redis.new("redis-url")
```

_Note: Data will be restored from the cache only if it is the same request to AWS client, the same filters and the same expiration time ._

```ruby
# Memory Caching.
require 'aws-dev-utils'
using AwsDevUtils::Refinements

ec2_client = Aws::EC2::Client.new
ec2_client.
  with_cache.
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])
```

```ruby
# Redis based caching with default experiation time (60 seconds).
require 'aws-dev-utils'
using AwsDevUtils::Refinements

AwsDevUtils::Cache.instance.backend = AwsDevUtils::Backend::Redis.new("redis-url")
ec2_client.
 with_cache.
 describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])
```

```ruby
# Redis based caching with custom expiration time (10 minutes).
require 'aws-dev-utils'
using AwsDevUtils::Refinements

AwsDevUtils::Cache.instance.backend = AwsDevUtils::Backend::Redis.new("redis-url")
ec2_client.
  with_cache(600).
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])
```

```ruby
# Example of different cache keys from requests.
require 'aws-dev-utils'
using AwsDevUtils::Refinements

AwsDevUtils::Cache.instance.backend = AwsDevUtils::Backend::Redis.new("redis-url")

# No cache data so request goes to AWS servers.
foo_1_instances = ec2_client.
  with_cache(600).
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])

# Different filters than foo_1_instances so request goes to AWS servers.
bar_1_instances = ec2_client.
  with_cache(600).
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-bar"]}])

# Same filters as bar_1_instances, so result is fetched from cache.
bar_2_instances = ec2_client.
  with_cache(600).
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-bar"]}])
```

### with_retry
By using the `client.with_retry`, the client functions will be retried in case of an exception (until the max number of retries is reached - the default is 5).  
Before each retry the client will sleep for an increasing number of seconds (implements exponential backoff)
```ruby
require 'aws-dev-utils'
using AwsDevUtils::Refinements

ec2_client = Aws::EC2::Client.new
# Retry 5 times (default):
ec2_client.
  with_retry.
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])

# Custom retries:
ec2_client.
  with_retry(3).
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])
```

### Combinations of wrappers
It is possible to combine between each of the wrappers:
```ruby
require 'aws-dev-utils'
using AwsDevUtils::Refinements

ec2_client = Aws::EC2::Client.new
#To retry 5 times:
ec2_client.
  with_retry.
  with_next_token.
  with_cache(600)
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])
```

## Contributing

### Releasing a new version
The `./release-new-version.sh` script will bump the version number. By default it will
increase by 0.0.1, but you can pass `minor` or `major` to increase it to the next
minor or major version accordingly.

The script will also create a git commit for the version bump, push it to this
GitHub repository and upload it to [rubygems.org](https://rubygems.org).

### Bugs and PRs
Bug reports and pull requests are welcome on GitHub at https://github.com/kontera-technologies/aws-dev-utils
