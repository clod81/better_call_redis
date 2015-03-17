# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'better_call_redis/version'

Gem::Specification.new do |spec|
  spec.name          = "better_call_redis"
  spec.version       = BetterCallRedis::VERSION
  spec.authors       = ["Claudio Contin"]
  spec.email         = ["contin@gmail.com"]
  spec.summary       = %q{Active Record Callback that pushes notification of creation or deletion to a Redis channel}
  spec.description   = %q{Redis pushes a message (notification) to a channel when an active record entry is created or deleted}
  spec.homepage      = "https://github.com/clod81/better_call_redis"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord",  ">= 3.0"
  spec.add_dependency "activesupport", ">= 3.0"
  spec.add_dependency "redis",         ">= 3.0.0"

  spec.add_development_dependency "bundler",                 ">= 1.6"
  spec.add_development_dependency "rake",                    "~> 10.0"
  spec.add_development_dependency "rspec",                   "~> 3.2.0"
end
