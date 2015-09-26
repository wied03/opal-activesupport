# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opal/activesupport/version'

Gem::Specification.new do |gem|
  gem.name          = 'opal-activesupport'
  gem.version       = Opal::Activesupport::VERSION
  gem.authors       = ['Elia Schito']
  gem.email         = ['elia@schito.me']
  gem.description   = %q{The port of the glorious ActiveSupport for Opal}
  gem.summary       = %q{The port of the glorious ActiveSupport for Opal}
  gem.homepage      = 'http://opalrb.org'
  gem.rdoc_options << '--main' << 'README' <<
                      '--line-numbers' <<
                      '--include' << 'opal'

  gem.files         = `git ls-files`.split($/)
  # TODO: This needs to be fixed to only include activesupport files
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'opal', ['>= 0.8.0.rc1', '< 0.9']
  gem.add_dependency 'opal-minitest', '~> 0.0'
  gem.add_development_dependency 'rake'
end
