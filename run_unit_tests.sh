#!/bin/bash -ex
# Copyright 2015 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

export SCRIPT_DIR=$(cd `dirname $0` && pwd -P)

mkdir .bundled_gems
export GEM_HOME=`pwd`/.bundled_gems

# Prove that gem build works
gem build puppet-openstack_infra_spec_helper.gemspec

# use puppet-openstackci to test the gem
if [ -e /usr/zuul-env/bin/zuul-cloner ] ; then
  /usr/zuul-env/bin/zuul-cloner --cache-dir /opt/git \
      git://git.openstack.org openstack-infra/puppet-openstackci
else
  git clone git://git.openstack.org/openstack-infra/puppet-openstackci openstack-infra/puppet-openstackci
fi
cd openstack-infra/puppet-openstackci

# Modify Gemfile to use local library and not the one on git
# so we can actually test the current state of the gem.
# Note this is largely belts and suspenders for local test runs.
# puppet-openstackci already attempts to determine if it is running
# under Zuul and will do the correct thing in that case.
sed -i "s/:git => 'https:\/\/git.openstack.org\/openstack-infra\/puppet-openstack_infra_spec_helper'}/:path => '..\/..'}/" Gemfile

# Install dependencies
gem install bundler --no-rdoc --no-ri --verbose

$GEM_HOME/bin/bundle install
