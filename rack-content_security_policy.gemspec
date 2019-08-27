# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/content_security_policy/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-content_security_policy'
  spec.version       = Rack::ContentSecurityPolicy::VERSION
  spec.authors       = ['Glenn Rempe']
  spec.email         = ['glenn@rempe.us']

  spec.summary       = 'Rack middleware for setting Content Security Policy (CSP) security headers'
  spec.description   = 'Rack middleware for declaratively setting the HTTP ContentSecurityPolicy (W3C CSP Level 2/3) security header to help prevent against XSS and other browser based attacks.'
  spec.homepage      = 'https://github.com/grempe/rack-content_security_policy'
  spec.license       = 'MIT'

  spec.files         = Dir.glob('lib/**/*') + %w(LICENSE.txt README.md)
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']
  spec.platform      = Gem::Platform::RUBY

  spec.required_ruby_version = '>= 2.2.5'

  cert = File.expand_path('~/.gem-certs/gem-private_key_grempe_2026.pem')
  if cert && File.exist?(cert)
    spec.signing_key = cert
    spec.cert_chain = ['certs/gem-public_cert_grempe_2026.pem']
  end

  spec.add_runtime_dependency 'rack'
  spec.add_runtime_dependency 'contracts', '~> 0.14'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rack-test', '~> 0.6'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'rubocop',   '~> 0.41'
  spec.add_development_dependency 'wwtd',      '~> 1.3'
end
