# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative '../Vagrantfile_base'

PRIVATE_IP = '33.33.33.10' unless defined? PRIVATE_IP

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Detects vagrant-cachier plugin
  if Vagrant.has_plugin?('vagrant-cachier')
    puts 'INFO:  Vagrant-cachier plugin detected. Optimizing caches.'
    # config.cache.auto_detect = true
    config.cache.enable :chef
    config.cache.enable :apt
    config.cache.enable :gem
  else
    puts 'WARN:  Vagrant-cachier plugin not detected. Continuing unoptimized.\n
                 You may install it with: "vagrant plugin install vagrant-cachier"'
  end

  # Box
  config.vm.box = 'opscode-ubuntu-13.10' # 14.04 seems to have problems with postgres installation
  config.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-13.10_chef-provisionerless.box'

  # VM
  config.vm.hostname = 'cwb-server-virtualbox'
  config.vm.network :private_network, ip: PRIVATE_IP

  # Virtualbox
  config.vm.provider :virtualbox do |vb|
    vb.memory = 3000
    vb.cpus = 4
  end

  # Chef solo
  config.vm.provision :chef_solo, id: 'chef_solo' do |chef|
    chef.json = CHEF_JSON.deep_merge!(
        {
            'cloud-benchmarking-server' => {
                'delayed_job' => {
                    'worker_processes' => '2'
                },
            },
            'rackbox' => {
                'default_config' => {
                    'unicorn' => {
                        'worker_processes' => '2',
                    }
                }
            },
            'postgresql' => {
                'config' => {
                    'max_connections' => '20'
                },
            }
        }
    )
  end
end
