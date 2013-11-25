# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'philbot/version'

Gem::Specification.new do |spec|
  spec.name        = 'philbot'
  spec.version     = Philbot::VERSION
  spec.authors     = ['pikesley']
  spec.email       = ['github@orgraphone.org']
  spec.description = %q{Cloudfiles client}
  spec.summary     = %q{Cloudfiles client}
  spec.homepage    = ''
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'resque', '~> 1.2'
  spec.add_dependency 'fog', '~> 1.18'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.1'
  spec.add_development_dependency 'cucumber', '~> 1.3'
  spec.add_development_dependency 'guard-cucumber', '~> 1.4'
  spec.add_development_dependency 'guard-rspec', '~> 4.0'
  spec.add_development_dependency 'terminal-notifier-guard'
  spec.add_development_dependency 'simplecov-rcov', '~> 0.2'
  spec.add_development_dependency 'aruba', '~> 0.5'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'resque-mock', '~> 0.1'
  spec.add_development_dependency 'coveralls', '~> 0.7'
  spec.add_development_dependency 'unf', '~> 0.1'
  spec.add_development_dependency 'librarian-chef'
end
