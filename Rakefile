require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

require 'echoe'

Echoe.new('shoutcast_api') do |gem|
  gem.version = '0.0.2'
  gem.author = 'Peter Suschlik'
  gem.summary = 'Simple Shoutcast.com API.'
  gem.email = 'peter-scapi@suschlik.de'
  gem.url = %q{http://github.com/splattael/shoutcast_api}
  gem.runtime_dependencies = [ "httparty ~>0.4", "roxml ~>2.5" ]
end
