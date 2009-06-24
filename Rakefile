require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

require 'echoe'
Echoe.new('shoutcast_api') do |gem|
  gem.version = '0.1.2'
  gem.author = 'Peter Suschlik'
  gem.summary = 'Simple shoutcast.com API.'
  gem.email = 'peter-scapi@suschlik.de'
  gem.url = %q{http://github.com/splattael/shoutcast_api}
  gem.runtime_dependencies = [ "httparty ~>0.4", "roxml ~>2.5" ]
  gem.ignore_pattern = ["tags"]
end

desc "Tag files for vim"
task :ctags do
  dirs = $LOAD_PATH.select {|path| File.directory?(path) }
  system "ctags -R #{dirs.join(" ")}"
end

desc "Find whitespace at line ends"
task :eol do
  system "grep -nrE ' +$' *"
end
