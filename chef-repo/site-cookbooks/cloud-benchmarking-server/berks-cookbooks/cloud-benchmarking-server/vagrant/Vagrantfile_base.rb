# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'cwb_config'
require_relative 'hash'
require 'pathname'

### MUST be provided by sub-Vagrantfiles
CONFIG_NAME = 'default' unless defined? CONFIG_NAME
APPLY_SECRET_CONFIG = false unless defined? APPLY_SECRET_CONFIG
SSH_USERNAME = 'ubuntu' unless defined? SSH_USERNAME
###

VAGRANT_BASE_DIR = Pathname.new(__FILE__).parent.expand_path
CHEF_REPO_DIR = Pathname.new(VAGRANT_BASE_DIR).parent.parent.parent.expand_path
COOKBOOKS_PATH = "#{VAGRANT_BASE_DIR}/../berks-cookbooks"
CONFIG_DIR = "#{CHEF_REPO_DIR}/secret/#{CONFIG_NAME}"

VAGRANTFILE_API_VERSION = '2'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Detects vagrant-omnibus plugin
  if Vagrant.has_plugin?('vagrant-omnibus')
    config.omnibus.chef_version = :latest
  else
    puts "FATAL: Vagrant-omnibus plugin not detected. Please install the plugin with\n
                 'vagrant plugin install vagrant-omnibus' from any other directory\n
                 before continuing."
    exit
  end

  # VM
  config.vm.hostname = 'cwb-server' # MUST not contain spaces
  config.ssh.forward_agent = true

  # Chef solo provisioning via berks-vendored cookbooks
  config.vm.provision :chef_solo, id: 'chef_solo' do |chef|
    chef.cookbooks_path = COOKBOOKS_PATH
    chef.provisioning_path = '/etc/chef'
    chef.run_list = [
        'recipe[cloud-benchmarking-server]'
    ]
  end
end

# Provide CHEF_JSON default config.
# Use "CHEF_JSON.deep_merge({<JSON_CONTENT>})" to override partial configuration
cwb_config = CwbConfig.new(config_dir: CONFIG_DIR,
                           apply_secrets: APPLY_SECRET_CONFIG,
                           ssh_username: SSH_USERNAME)
CHEF_JSON = cwb_config.chef_config
