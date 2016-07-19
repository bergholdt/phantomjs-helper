# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'phantomjs/helper/version'

Gem::Specification.new do |s|
  s.name        = 'phantomjs-helper'
  s.version     = Phantomjs::Helper::VERSION
  s.authors     = ['Rasmus Bergholdt']
  s.email       = ['rasmus.bergholdt@gmail.com']
  s.homepage    = 'https://github.com/bergholdt/phantomjs-helper'
  s.summary     = 'Easy installation and use of Phantomjs.'
  s.description = 'Easy installation and use of Phantomjs.'
  s.licenses    = ['MIT']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rake', '~> 11.2'

  s.add_runtime_dependency 'nokogiri', '~> 1.6'
  s.add_runtime_dependency 'rubyzip'
  s.add_runtime_dependency 'ffi-libarchive'
end
