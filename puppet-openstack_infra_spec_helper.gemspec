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
  spec.add_dependency 'puppet', ['3']
  spec.add_dependency 'puppetlabs_spec_helper'
  spec.add_dependency 'metadata-json-lint'
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
  spec.add_dependency 'webmock'
  # google-api-client requires Ruby version ~> 2.0
  spec.add_dependency 'google-api-client', ['0.9.4']
  # latest specinfra broke us, we pin it until we figure what's wrong.
  spec.add_dependency 'specinfra', ['2.59.0']

  # dependencies that are needed to run beaker-rspec
  spec.add_dependency 'beaker-rspec'
  spec.add_dependency 'beaker-puppet_install_helper'
end
