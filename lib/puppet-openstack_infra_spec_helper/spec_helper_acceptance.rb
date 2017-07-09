require 'beaker-rspec'

SYSTEM_CONFIG='git.openstack.org/openstack-infra/system-config'

def install_infra_puppet(host)
  install_system_config(host)
  on host, "bash -x #{ENV['HOME']}/src/#{SYSTEM_CONFIG}/install_puppet.sh", :environment => ENV.to_hash
  if ENV['PUPPET_VERSION'] == '4'
    host.ssh_permit_user_environment()
    host.add_env_var('PATH', '/opt/puppetlabs/bin')
  end
end

def setup_host(host)
  add_platform_foss_defaults(host, 'unix')
end

def install_system_config(host)
  install_package host, 'git'
  on host, "test -d #{ENV['HOME']}/src/#{SYSTEM_CONFIG} || git clone https://#{SYSTEM_CONFIG} #{ENV['HOME']}/src/#{SYSTEM_CONFIG}"
end

def install_infra_modules(host, proj_root)
  # Clean out any module cruft
  if ENV['PUPPET_VERSION'] == '4'
    on host, 'rm -fr /etc/puppetlabs/code/modules/*'
  else
    on host, 'rm -fr /etc/puppet/modules/*'
  end

  # Install module and dependencies
  modname = JSON.parse(open('metadata.json').read)['name'].split('-')[1]
  module_install_cmd = "bash #{ENV['HOME']}/src/#{SYSTEM_CONFIG}/tools/install_modules_acceptance.sh"
  on host, module_install_cmd, :environment => ENV.to_hash
  if ENV['PUPPET_VERSION'] == '4'
    on host, "rm -fr /etc/puppetlabs/code/modules/#{modname}"
  else
    on host, "rm -fr /etc/puppet/modules/#{modname}"
  end

  # Install the module being tested
  opts = {:source => proj_root, :module_name => modname}
  if ENV['PUPPET_VERSION'] == '4'
    opts[:target_module_path] = '/etc/puppetlabs/code/modules'
  end
  puppet_module_install(opts)
  # List modules installed to help with debugging
  # debug
  on host, 'cat ~/.ssh/environment'
  on host, 'echo $PATH'
  on host, 'cat /etc/ssh/sshd_config'
  on host, 'cat /etc/profile.d/puppet-agent.sh'
  on host, 'which puppet'
  on host, puppet('module','list'), { :acceptable_exit_codes => 0 }
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
