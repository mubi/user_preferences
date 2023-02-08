# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'user_preferences/version'

Gem::Specification.new do |spec|
  spec.name          = "user_preferences"
  spec.version       = UserPreferences::VERSION
  spec.authors       = ["Andy Dust"]
  spec.email         = ["adust@mubi.com"]
  spec.summary       = "User preferences gem for Rails."
  spec.description   = %Q{user_preference is a small library for setting and getting categorized user preferences.
                      Supports both binary and multivalue preferences and default values. }
  spec.homepage      = "http://github.com/mubi/user_preferences"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '>= 4.0'

  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency 'rspec', '~> 3.9.0'
  spec.add_development_dependency 'sqlite3'
end
