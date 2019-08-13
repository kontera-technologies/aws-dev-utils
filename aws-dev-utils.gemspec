# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'aws-dev-utils/version'

Gem::Specification.new do |s|
  s.name          = 'aws-dev-utils'
  s.version       = AwsDevUtils::VERSION
  s.authors       = ['Infastructure']
  s.email         = ['infra@amobee.com']
  s.homepage      = 'https://github.com/kontera-technologies/aws-dev-utils'
  s.licenses      = ['MIT']
  s.summary       = 'Ruby library gem that provides common AWS utilities'
  s.description   = ''

  s.files         = Dir["README.md", "LICENSE", "lib/**/*"]
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.5.0'
  s.add_runtime_dependency 'aws-sdk-core', '>= 2.0.0'
  s.add_runtime_dependency 'deepsort', '~> 0.4.2'
end
