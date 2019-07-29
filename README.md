# AWS Dev Utilities [![Build Status](https://travis-ci.org/kontera-technologies/aws-dev-utils.svg?branch=master)](https://travis-ci.org/kontera-technologies/aws-dev-utils) [![codecov](https://codecov.io/gh/kontera-technologies/aws-dev-utils/branch/master/graph/badge.svg)](https://codecov.io/gh/kontera-technologies/aws-dev-utils)

This library provides common ruby utilities to working with AWS SDK. It simplifies the work by reducing common boilerplates such as "next_token" pagination and "retry". 
It provides a general API Wrapper with Redis based caching, paging and retry functionalities.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws-dev-utils'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gem 'aws-dev-utils'

## Usage
_Note: Before using `with_next_token` / `with_cache` / `with_retry` functions:

```ruby
require 'aws-dev-utils'
using AwsDevUtils::Refinements
```

## NextToken
Many AWS operations limit the number of results returned with each response. To make it easy to get the next page of results, every AWS response object is enumerable. <br>This functionallity is rarely needed and causes a lot of boilerplate code.<br>
Using the `client.with_next_token` the paged results will be collected for you. 
The AWS client function and its results will be concatenated until either no more results are available or the max number of requests is reached.

It is also possible to use the `client.with_next_token` also for AWS API responses that contains `next_marker` or `next_continuation_token` 

```ruby
require 'aws-dev-utils'
using AwsDevUtils::Refinements

ec2_client = Aws::EC2::Client.new
#To get the whole set of results:
ec2_client.
  with_next_token.
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])
 
#To limit the number of pages in the result:
ec2_client.
  with_next_token(5).
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])
```

## Cache
In many cases a cache is required due to many processes or different machines querying the AWS api for data.  
By using the `client.with_cache`, the client functions results will be stored in cache. <br>
The default cache is a simple in memory *time based* store - `AwsDevUtils::Backend::Memory` <br>
Incase in-memory cache is not a good solution then there is  also `Redis` based caching (`AwsDevUtils::Backend::Redis`).
To use it start a Redis instance:
```ruby
AwsDevUtils::Cache.instance.backend = AwsDevUtils::Backend::Redis.new("redis-url")
```

_Note: Data will be restored from the cache only if it is the same request to AWS client, the same filters and the same expiration time ._

```ruby
require 'aws-dev-utils'
using AwsDevUtils::Refinements

ec2_client = Aws::EC2::Client.new
#To use memory caching
ec2_client.
  with_cache.
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])
 
#To use Redis caching- with 60 seconds of data expiration (default)
AwsDevUtils::Cache.instance.backend = AwsDevUtils::Backend::Redis.new("redis-url")
ec2_client.
  with_cache.
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])

#To use Redis caching- and set the seconds of data expiration
AwsDevUtils::Cache.instance.backend = AwsDevUtils::Backend::Redis.new("redis-url")
ec2_client.
  with_cache(600).
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])

```

## Retry
By using the `client.with_retry`, the client functions will be retried in case of an exception (until the max number of retries is reached - the default is 5).

```ruby
require 'aws-dev-utils'
using AwsDevUtils::Refinements

ec2_client = Aws::EC2::Client.new
#To retry 5 times:
ec2_client.
  with_retry.
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])
 
#To limit the number of recalling the function:
ec2_client.
  with_retry(3).
  describe_instances(filters:[{ name: "vpc-id", values: ["vpc-foo"]}])
```

## Combinations of wrappers
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

## Release new version
The `./release-new-version.sh` script will bump the version number. By default it will
increase by 0.0.1, but you can pass `minor` or `major` to increase it to the next
minor or major version accordingly.

The script will also create a git commit for the version bump, push it to this
GitHub repository and upload it to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kontera-technologies/aws-dev-utils
