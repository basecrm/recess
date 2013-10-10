# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'recess/version'

Gem::Specification.new do |spec|
  spec.name          = "recess"
  spec.version       = Recess::VERSION
  spec.authors       = ["Antek Piechnik", "Felipe Elias Philipp"]
  spec.email         = ["antek.piechnik@gmail.com", "felipeelias@gmail.com"]
  spec.description   = %q{Simple nested timeouts based on Timeout.}
  spec.summary       = %q{Simple nested timeouts.}
  spec.homepage      = "https://github.com/basecrm/recess"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
