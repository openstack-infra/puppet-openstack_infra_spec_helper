Puppet-OpenStack-Infra Spec Helper
==================================

This gem provides helper utilities for running rspec tests in the
[OpenStack Infra Modules](http://docs.openstack.org/infra/system-config/sysadmin.html).

Usage
-----

Include this gem in your Gemfile:

```
gem 'puppet-openstack_infra_spec_helper',
  :git => 'https://git.openstack.org/openstack-infra/puppet-openstack_infra_spec_helper',
  :require => false
```

In your Rakefile, require the rake\_tasks library:

```
require 'puppet-openstack_infra_spec_helper/rake_tasks'
```

Instructions for using `puppet-openstack_infra_spec_helper/beaker_spec_helper` in
`spec/spec_helper_acceptance.rb` to come soon.
