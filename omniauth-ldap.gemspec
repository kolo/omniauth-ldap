$:.push File.expand_path("../lib", __FILE__)
require 'omniauth-ldap/version'

Gem::Specification.new do |g|
  g.name = "omniauth-ldap"
  g.version = OmniAuth::LDAP::Version
  g.platform = Gem::Platform::RUBY
  g.authors = ["Dmitry Maksimov"]
  g.email = ["dmtmax@gmail.com"]
  g.homepage = ""
  g.summary = %{LDAP strategry for OmniAuth gem.}
  g.description = %{LDAP strategry for OmniAuth gem.}

  g.files = `git ls-files`.split("\n")
  g.require_paths = ["lib"]

  g.add_dependency "net-ldap"
end
