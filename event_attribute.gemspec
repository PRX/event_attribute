# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'event_attribute/version'

Gem::Specification.new do |spec|
  spec.name          = "event_attribute"
  spec.version       = EventAttribute::VERSION
  spec.authors       = ["Jonathan Younger", "Andrew Kuklewicz", "chrisrhoden"]
  spec.email         = ["chris@prx.org"]
  spec.description   = %q{EventAttribute allows you to turn your date/datetime columns in to boolean attributes in ActiveRecord.}
  spec.summary       = %q{Idea for this was taken from http://jamis.jamisbuck.org/articles/2005/12/14/two-tips-for-working-with-databases-in-rails}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_dependency "activesupport", ">= 3.0.0"

  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
