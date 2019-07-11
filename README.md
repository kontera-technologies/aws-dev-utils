# AWS Utilities [![Build Status]()]() [![codecov]()]()

Provides common ruby utilities to working with AWS.

## `AwsDevUtils::NextTokenWrapper`
Adds the `with_next_token` method to all `AWS` client objects.
By using the `NextTokenWrapper`, the `AWS` client functions will be re-executed
and their results will be concatenated until either no more results are available
or the max number of requests is reached.

_Note: Before using this function, add `using AwsDevUtils::Refinements` to add the
method to the AWS client objects._

### Examples:
- `s3_client.with_next_token.list_objects_v2(...)`
- `s3_client.with_next_token(50).list_buckets(...)`
- `ec2_client.with_next_token.describe_reserved_instances(...)`
- `pricing_client.with_next_token.get_products(...)`

## `AwsDevUtils::RetryWrapper`
Adds the `with_retry` method to all `AWS` client objects.
By using the `RetryWrapper`, the client functions will be retried in case of an
exception (until the max number of retries is reached).

_Note: Before using this function, add `using AwsDevUtils::Refinements` to add the
method to the AWS client objects._

### Examples:
- `s3_client.with_retry.list_objects_v2(...)`
- `ec2_client.with_retry(10).describe_reserved_instances(...)`
- `pricing_client.with_retry.get_products(...)`

## Release new version
The `./release-new-version.sh` script will bump the version number. By default it will
increase by 0.0.1, but you can pass `minor` or `major` to increase it to the next
minor or major version accordingly.

The script will also create a git commit for the version bump, push it to this
GitHub repository and upload it to [rubygems.org](https://rubygems.org).
