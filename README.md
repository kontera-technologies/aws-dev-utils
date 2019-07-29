# AWS Dev Utilities [![Build Status](https://travis-ci.org/kontera-technologies/aws-dev-utils.svg?branch=master)](https://travis-ci.org/kontera-technologies/aws-dev-utils) [![codecov](https://codecov.io/gh/kontera-technologies/aws-dev-utils/branch/master/graph/badge.svg)](https://codecov.io/gh/kontera-technologies/aws-dev-utils)

This library provides common ruby utilities to working with AWS SDK. It provides a general API Wrapper with Redis based Caching, paging and retry functionalities.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws-dev-utils'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gem 'aws-dev-utils'


## Release new version
The `./release-new-version.sh` script will bump the version number. By default it will
increase by 0.0.1, but you can pass `minor` or `major` to increase it to the next
minor or major version accordingly.

The script will also create a git commit for the version bump, push it to this
GitHub repository and upload it to [rubygems.org](https://rubygems.org).


### Disclaimer
This project is still in its early stages so things could be a little bit buggy, if you find one feel free to [report](https://github.com/kontera-technologies/aws-dev-utils/issues) it.
