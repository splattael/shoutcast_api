# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{shoutcast_api}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter Suschlik"]
  s.date = %q{2009-05-14}
  s.email = %q{peter-scapi@suschlik.de}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/splattael/shoutcast_api}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple Shoutcast.com API.}

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
