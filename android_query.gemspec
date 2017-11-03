# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "android_query/version"

Gem::Specification.new do |spec|
  spec.name          = "android_query"
  spec.version       = AndroidQuery::VERSION
  spec.authors       = ["Abdullah Esmail"]
  spec.email         = ["abdullah.esmail@gmail.com"]

  spec.summary       = %q{Making android development easy and enjoyable}
  spec.description   = %q{This gem was inspired by the rmq gem for iOS}
  spec.homepage      = "https://github.com/aesmail/android-query"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end
