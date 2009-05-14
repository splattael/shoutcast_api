require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/test_*.rb')
  test.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "shoutcast_api"
    gem.summary = 'Simple Shoutcast.com API.'
    gem.authors = ['Peter Suschlik']
    gem.email = 'peter-scapi@suschlik.de'
    gem.homepage = %q{http://github.com/splattael/shoutcast_api}
    gem.has_rdoc = true
    gem.extra_rdoc_files = %w(README.rdoc)

    gem.add_dependency 'httparty', '~> 0.4'
    gem.add_dependency 'roxml', '~> 2.5'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
