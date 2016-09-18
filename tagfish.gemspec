# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tagfish/version'

Gem::Specification.new do |spec|
  spec.name          = "tagfish"
  spec.version       = Tagfish::VERSION
  spec.authors       = ["Clement Labbe"]
  spec.email         = ["clement.labbe@rea-group.com"]
  spec.summary       = %q{Command line utility for docker registries}
  spec.description   = "Retrieve repository tags, update dockerfiles, and more!"
  spec.homepage      = "https://github.com/realestate-com-au/tagfish"
  spec.license       = "MIT"

  spec.files         = Dir.glob("{bin,lib}/**/*")
  spec.bindir        = "bin"
  spec.executables   = ["tagfish"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3.0"
  spec.add_dependency "clamp", "~> 1.0.0"
  spec.add_dependency "diffy", "~> 3.0.0"
  spec.add_dependency "json", "~> 1.8.0"
end
