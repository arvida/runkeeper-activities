require File.expand_path("../lib/runkeeper_activities/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'runkeeper-activites'
  s.version     = RunKeeperActivites::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Arvid Andersson']
  s.email       = ['arvid.andersson@oktavilla.se']
  s.homepage    = 'http://github.org/arvida/runkeeper-activites'
  s.summary     = 'Scraper for latest activites on RunKeeper'
  s.description = 'A ruby interface for the latest activites on RunKeeper'

  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency 'bundler', '>= 1.0.0'
  s.add_development_dependency 'addressable', '>= 2.2.6'
  s.add_development_dependency 'webmock', '>= 1.6.4'

  s.add_dependency('nokogiri', '>= 1.4.4')
  s.add_dependency('yajl-ruby', '>= 0.8.2')

  s.files        = Dir.glob("{test,lib}/**/*") + %w(README.rdoc runkeeper-activities.gemspec Rakefile Gemfile)
  s.require_path = 'lib'
end
