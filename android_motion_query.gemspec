# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "android_motion_query/version"

Gem::Specification.new do |spec|
  spec.name          = "android_motion_query"
  spec.version       = AndroidQuery::VERSION
  spec.authors       = ["Abdullah Esmail"]
  spec.email         = ["abdullah.esmail@gmail.com"]
  spec.summary       = %q{Making RubyMotion android development easy and enjoyable}
  spec.description   = %q{Making RubyMotion android development easy and enjoyable}
  spec.homepage      = "https://github.com/aesmail/android-motion-query"
  spec.license       = "MIT"
  spec.files         = Dir.glob('lib/**/*.rb') << 'README.md' << 'LICENSE.txt'
  spec.require_paths = ["lib"]
  spec.add_development_dependency "rake"
end
