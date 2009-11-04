# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{splattael-shoutcast_api}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter Suschlik"]
  s.date = %q{2009-11-04}
  s.default_executable = %q{shoutcast_search}
  s.description = %q{Simple Shoutcast.com API.}
  s.email = %q{peter-scapi@suschlik.de}
  s.executables = ["shoutcast_search"]
  s.extra_rdoc_files = ["bin/shoutcast_search", "lib/shoutcast_api.rb", "README.rdoc"]
  s.files = ["Rakefile", "bin/shoutcast_search", "lib/shoutcast_api.rb", "README.rdoc", "Manifest", "test/test_xml.rb", "test/helper.rb", "test/test_fetcher.rb", "test/fixtures/genrelist.plain", "test/fixtures/search_death.plain", "test/fixtures/empty.plain", "test/test_basic.rb", "shoutcast_api.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/splattael/shoutcast_api}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Shoutcast_api", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{shoutcast_api}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ruby API for Shoutcast.com.}
  s.test_files = ["test/test_xml.rb", "test/test_fetcher.rb", "test/test_basic.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, ["~> 0.4"])
      s.add_runtime_dependency(%q<roxml>, ["~> 2.5"])
    else
      s.add_dependency(%q<httparty>, ["~> 0.4"])
      s.add_dependency(%q<roxml>, ["~> 2.5"])
    end
  else
    s.add_dependency(%q<httparty>, ["~> 0.4"])
    s.add_dependency(%q<roxml>, ["~> 2.5"])
  end
end
