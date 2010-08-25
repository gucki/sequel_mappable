#!/usr/bin/env gem build
# -*- encoding: utf-8 -*-

require 'date'
require File.expand_path("../lib/sequel_mappable/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name     = 'sequel_mappable'
  gem.version  = Sequel::Plugins::Mappable::VERSION.dup
  gem.authors  = ['Corin Langosch']
  gem.date     = Date.today.to_s
  gem.email    = 'info@netskin.com'
  gem.homepage = 'http://github.com/gucki/sequel_mappable'
  gem.summary  = 'Sequel plugin which provides distance-based filters and distance calculation functionality for model.'
  gem.description = gem.summary

  gem.has_rdoc = true 
  gem.require_paths = ['lib']
  gem.extra_rdoc_files = ['README.rdoc', 'LICENSE', 'CHANGELOG']
  gem.files = Dir['Rakefile', '{lib,spec}/**/*', 'README*', 'LICENSE*', 'CHANGELOG*'] & `git ls-files -z`.split("\0")

  gem.add_dependency 'sequel', ">= 3.0.0"
  gem.add_dependency 'geokit', ">= 1.5.0"
  gem.add_development_dependency 'sqlite3-ruby'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'yard'
end
