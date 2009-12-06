require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "shoutcast_api"
  gem.summary = 'Simple shoutcast.com API.'
  gem.email = "peter-scapi@suschlik.de"
  gem.homepage = "http://github.com/splattael/shoutcast_api"
  gem.authors = ["Peter Suschlik"]

  gem.has_rdoc = true
  gem.extra_rdoc_files = [ "README.rdoc" ]
  
  gem.add_dependency 'httparty', '~> 0.4'
  gem.add_dependency 'roxml', '~> 2.5'

  gem.add_development_dependency "mocha"
  gem.add_development_dependency "riot", ">= 0.10.4"
  gem.add_development_dependency "riot_notifier", ">= 0.0.3"

  gem.test_files = Dir.glob('test/test_*.rb')
end

Jeweler::GemcutterTasks.new

# Test
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/test_*.rb')
  test.libs << 'test'
  test.verbose = true
end

# RDoc
Rake::RDocTask.new do |rd|
  rd.title = "Shoutcast API"
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/*.rb")
  rd.rdoc_dir = "doc"
end


# Misc
desc "Tag files for vim"
task :ctags do
  dirs = $LOAD_PATH.select {|path| File.directory?(path) }
  system "ctags -R #{dirs.join(" ")}"
end

desc "Find whitespace at line ends"
task :eol do
  system "grep -nrE ' +$' *"
end
