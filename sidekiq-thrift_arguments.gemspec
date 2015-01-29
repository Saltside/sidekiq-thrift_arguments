# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "sidekiq-thrift_arguments"
  spec.version       = "0.2.0"
  spec.authors       = ["ahawkins"]
  spec.email         = ["adam@hawkins.io"]
  spec.summary       = %q{Transparently serialize/deserialize Thirft structs used a Sidekiq job arguments}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/saltside/sidekiq-thrift_arguments"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sidekiq"
  spec.add_dependency "thrift-base64"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
