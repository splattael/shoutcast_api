# -*- encoding: utf-8 -*-

require File.expand_path('../lib/shoutcast_api', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Peter Suschlik"]
  gem.email         = ["peter-scapi@suschlik.de"]
  gem.description   = %q{Simple API for shoutcast.com}
  gem.summary       = %q{Uses httparty and roxml for fetching and parsing data from http://yp.shoutcast.com/sbin/newxml.phtml}
  gem.homepage      = "https://github.com/splattael/shoutcast_api"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "shoutcast_api"
  gem.require_paths = ["lib"]
  gem.version       = Shoutcast::VERSION

  gem.add_runtime_dependency 'httparty', '~> 0.8.3'
  gem.add_runtime_dependency 'roxml', '~> 3.3.1'

  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'riot', '~> 0.12.2'
end
