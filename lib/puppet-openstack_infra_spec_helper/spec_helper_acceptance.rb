require 'beaker-rspec'

SYSTEM_CONFIG='openstack-infra/system-config'

def install_infra_puppet(host)
  # puppet 3 isn't available from apt.puppetlabs.com so install it from the Xenial repos
  on host, "which apt-get && apt-get install puppet -y", { :acceptable_exit_codes => [0,1] }
  # otherwise use the beaker helpers to install the yum.puppetlabs.com repo and puppet
  r = on host, "which yum",  { :acceptable_exit_codes => [0,1] }
  if r.exit_code == 0
    install_puppet
  end
end

def setup_host(host)
  add_platform_foss_defaults(host, 'unix')
  on host, "mkdir -p #{host['distmoduledir']}"
end

def install_system_config(host)
  # install git
  install_package host, 'git'

  # Install dependent modules via git or zuul
  on host, "rm -fr #{SYSTEM_CONFIG}"
  if ENV['ZUUL_REF'] && ENV['ZUUL_BRANCH'] && ENV['ZUUL_URL']
    zuul_clone_cmd = '/usr/zuul-env/bin/zuul-cloner '
    zuul_clone_cmd += '--cache-dir /opt/git '
    zuul_clone_cmd += "--zuul-ref #{ENV['ZUUL_REF']} "
    zuul_clone_cmd += "--zuul-branch #{ENV['ZUUL_BRANCH']} "
    zuul_clone_cmd += "--zuul-url #{ENV['ZUUL_URL']} "
    zuul_clone_cmd += "git://git.openstack.org #{SYSTEM_CONFIG}"
    on host, zuul_clone_cmd
  else
    on host, "git clone https://git.openstack.org/#{SYSTEM_CONFIG} #{SYSTEM_CONFIG}"
  end
end

def install_infra_modules(host, proj_root)
  install_system_config(host)
  # Clean out any module cruft
  shell('rm -fr /etc/puppet/modules/*')

  # Install module and dependencies
  modname = JSON.parse(open('metadata.json').read)['name'].split('-')[1]
  module_install_cmd = "ZUUL_REF=#{ENV['ZUUL_REF']} "
  module_install_cmd += "ZUUL_BRANCH=#{ENV['ZUUL_BRANCH']} "
  module_install_cmd += "ZUUL_URL=#{ENV['ZUUL_URL']} "
  module_install_cmd += "bash #{SYSTEM_CONFIG}/tools/install_modules_acceptance.sh"
  on host, module_install_cmd
  on host, "rm -fr /etc/puppet/modules/#{modname}"

  # Install the module being tested
  puppet_module_install(:source => proj_root, :module_name => modname)
  # List modules installed to help with debugging
  on hosts[0], puppet('module','list'), { :acceptable_exit_codes => 0 }
end

proj_root = File.expand_path(File.join(Dir.getwd))

# Make sure proj_root is the real project root
unless File.exists?("#{proj_root}/metadata.json")
  raise "bundle exec rspec spec/acceptance needs be run from module root."
end

# Readable test descriptions
RSpec.configure do |conf|
  conf.formatter = :documentation
end

# Set up hosts, before running any tests
hosts.each do |host|
  install_infra_puppet(host)
  setup_host(host)
  install_infra_modules(host, proj_root)
end
