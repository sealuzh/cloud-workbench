# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative '../Vagrantfile_base'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # VM
  config.vm.hostname = 'cwb-server-aws'

  # Box
  config.vm.box     = 'aws'
  config.vm.box_url = 'https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box'

  # AWS EC2 provider
  config.vm.provider :aws do |aws, override|
    # AWS authentication
    aws.access_key_id     = ENV['AWS_ACCESS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET_KEY']

    # AWS instance configuration
    aws.region = 'eu-west-1'
    # Official Ubuntu 13.10 LTS amd64 EBS image from Canonical: https://cloud-images.ubuntu.com/locator/ec2/
    aws.ami = 'ami-b72ee8c0'
    aws.keypair_name = ENV['EC2_KEYPAIR']
    override.ssh.private_key_path = ENV['EC2_PRIVATE_KEY']
    override.ssh.username = SSH_USERNAME
    aws.instance_type = 'm1.small'
    aws.security_groups = ['aic13-cloud_benchmarking-web']
    aws.tags = {
        'Name' => 'CWB-Server'
    }
  end
end
