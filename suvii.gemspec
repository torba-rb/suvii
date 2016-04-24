Gem::Specification.new do |spec|
  spec.name          = "suvii"
  spec.version       = "0.1.0"
  spec.authors       = ["Andrii Malyshko"]
  spec.email         = ["mail@nashbridges.me"]
  spec.description   = "Read from a remote tar.gz/zip archive easily"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/torba-rb/suvii"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rubyzip", "~> 1.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "minitest", "~> 5.4"
  spec.add_development_dependency "webmock", "~> 1.24"
  spec.add_development_dependency "assert_dirs_equal", "~> 0.2"
end
