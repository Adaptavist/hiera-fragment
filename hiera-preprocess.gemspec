# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'hiera-fragment'
  spec.version       = '0.0.1'
  spec.authors       = ['Jon Mort']
  spec.email         = ['jmort@adaptavist.com']
  spec.summary       = %q{Merges YAML fragments into YAML documents}
  spec.description   = %q{Takes YAML fragments and merges them into a larger document as par of a Hiera pre-process phase}
  spec.homepage      = ''
  spec.license       = 'Proprietary'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'ruby-lint'
  spec.add_dependency 'deep_merge'
  spec.add_dependency 'hiera'
end
