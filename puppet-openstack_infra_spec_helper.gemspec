lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet-openstack_infra_spec_helper/version'

Gem::Specification.new do |spec|
  spec.name          = "puppet-openstack_infra_spec_helper"
  spec.version       = PuppetOpenstackInfraSpecHelper::Version::STRING
  spec.authors       = ["OpenStack Infrastructure Team"]
  spec.description   = %q{Helpers for module testing}
  spec.summary       = %q{Puppet-OpenStack-Infra spec helper}
  spec.homepage      = ""
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # dependencies that are needed to run puppet-lint
  spec.add_dependency 'puppet', [ '~> 3.8']
  spec.add_dependency 'puppetlabs_spec_helper'
  # metadata-job-lint 2.0 requires Ruby version ~> 2.0
  spec.add_dependency 'metadata-json-lint', ['< 2.0.0']
  spec.add_dependency 'puppet-lint-absolute_classname-check'
  spec.add_dependency 'puppet-lint-absolute_template_path'
  spec.add_dependency 'puppet-lint-trailing_newline-check'

  spec.add_dependency 'puppet-lint-unquoted_string-check'
  spec.add_dependency 'puppet-lint-leading_zero-check'
  spec.add_dependency 'puppet-lint-variable_contains_upcase'
  spec.add_dependency 'puppet-lint-spaceship_operator_without_tag-check'
  spec.add_dependency 'puppet-lint-undef_in_function-check'
  spec.add_dependency 'json'
  spec.add_dependency 'netaddr'
  # webmock 3.0 requires Ruby version ~> 2.0
  spec.add_dependency 'webmock', ['< 3.0.0']
  # google-api-client requires Ruby version ~> 2.0
  spec.add_dependency 'google-api-client', ['0.9.4']
  # latest json_pure requires Ruby version ~> 2.0
  spec.add_dependency 'json_pure', ['2.0.1']
  # latest specinfra broke us, we pin it until we figure what's wrong.
  spec.add_dependency 'specinfra', ['2.59.0']
  # fast_gettext 1.2.0+ requires ruby 2.1.0 which is not available on centos7
  spec.add_dependency 'fast_gettext', ['< 1.2.0']
  # nokogiri 1.7.0+ requires ruby 2.1.0 which is not available on centos7
  spec.add_dependency 'nokogiri', ['< 1.7.0']
  # fog-core 1.44.0 requires xmlrpc 0.3.0 which requires ruby 2.3.0 which is not available on centos7
  spec.add_dependency 'fog-core', ['!= 1.44.0']

  # Beaker 3.0.0 fails to run in Puppet Openstack CI
  # LoadError: cannot load such file -- serverspec
  # While we're investigating it, let's pin Beaker to 2.x releases.
  spec.add_dependency 'beaker', ['< 3.0.0']

  # dependencies that are needed to run beaker-rspec
  spec.add_dependency 'beaker-rspec'
  spec.add_dependency 'beaker-puppet_install_helper'
end
