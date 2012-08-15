# -*- encoding: utf-8 -*-
require File.expand_path('../lib/GMaps_Places/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alexandr Kovtunov"]
  gem.email         = ["1sasha.sasha1@gmail.com"]
  gem.description   = %q{GMaps_Places Gem for rbGarage courses}
  gem.summary       = %q{A small gem for Google Places API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "GMaps_Places"
  gem.require_paths = ["lib"]
  gem.version       = GMaps_Places::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "json"
end
