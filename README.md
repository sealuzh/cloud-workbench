# Cloud Benchmarking

## Installation

### Requirements
* Git (1.9.2)
* [Vagrant (1.5.4)](https://www.vagrantup.com/downloads)
    * [chef (11.6.2)](https://rubygems.org/gems/chef/versions/11.6.2)
    * [vagrant-omnibus (1.3.1)](https://github.com/schisamo/vagrant-omnibus)
    * [[optional] vagrant-aws (0.4.1)](https://github.com/mitchellh/vagrant-aws)
        * For AWS EC2 Cloud
    * [[optional] vagrant-berkshelf (2.0.1 or 2.0.0rc3)](https://github.com/berkshelf/vagrant-berkshelf)
        * For development with staging and development environment. Be aware that this plugin may cause unexpected installation issues.
    * [[optional] vagrant-cachier (0.7.0)](https://github.com/fgrehm/vagrant-cachier)
        * For optimized local development with VirtualBox


1. Vagrant can be easily installed with the installer for your system from [https://www.vagrantup.com/downloads](https://www.vagrantup.com/downloads)
2. The Vagrant plugins can be installed with this one-liner:

```bash
vagrant plugin install vagrant-aws; vagrant plugin install vagrant-omnibus; vagrant plugin install chef
```

### Initial Configuration
1. Checkout the Git repository `https://bitbucket.org/sealuzh/cloud-benchmarking`
2. Provide the following environment variables for the AWS EC2 Cloud configuration:
    * AWS_ACCESS_KEY => Your AWS access key
    * AWS_SECRET_KEY => Your AWS secret key
    * EC2_KEYPAIR => Name of the AWS private key for ssh access (usually the same as the file-name but without file-extension)
    * EC2_PRIVATE_KEY => Path to your AWS private key for ssh access
	
An example configuration that can be used with your `~/.profile` or `~/.bash_profile` is shown below:

```
export AWS_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export EC2_KEYPAIR=my-key-pair-ireland
export EC2_PRIVATE_KEY=$HOME/.ssh/my-key-pair-ireland.pem
```
Note: The provided values are examples from AWS and do NOT work.

### Install WorkBench Server
1. `cd $GIT_REPO_HOME/cloud_benchmarking/chef-repo/site-cookbooks/cloud-benchmarking-server/vagrant-aws-production`
2. `vagrant up --provider=aws`

#### Configure WorkBench Server
TODO:
 * Docs/automation for
 * Note about time (NTP cookbook)


* Environment variables: `/home/apps/.profile`
* Knife config file: `/home/apps/.chef/knife.rb`

Consider: permissions, dynamic directories (node[appdir])

### Install Chef Server
1. `cd $GIT_REPO_HOME/cloud_benchmarking/chef-repo/site-cookbooks/cbench-chef-server/vagrant-aws-production`
2. `vagrant up --provider=aws`

## Reconfiguration on IP address change

### WorkBench

* Data bag item in Chefserver
	1. `https://$CHEF_SERVER_IP/databags/benchmark/databag_items/workbench_server`
	2. Enter the IP address of the WorkBench here
* Capistrano deployment config (only for deployment)
    1. `vim $GIT_REPO_HOME/cloud_benchmarking/config/deploy/production.rb`
    2. Enter the IP address of the WorkBench here


### Chef Server

* WorkBench ~/.profile
    1. `cd $GIT_REPO_HOME/cloud_benchmarking/chef-repo/site-cookbooks/cloud-benchmarking-server/vagrant-aws-production`
    2. `vagrant ssh`
    3. `sudo vim /home/apps/.profile`
    4. Enter the IP address of the Chef Server here
* Workstation knife.rb
    1. `vim $HOME/.chef/knife.rb`
    2. Enter the IP address of the Chef Server here


## Benchmarks

### Getting Started

## Limitations

* Only AWS as provider supported due to the following dependencies
  * Client side BenchmarkHelper uses AWS metadata API
	* Vagrant up does not support multiple providers
* Only single machine VM setting supported (Vagrant default VM)
* Only single AWS region supported due to fix private key in server
* No user authentication and authorization (also technical user)
* Chef cookbooks must be uploaded to the Chef server

* Log files from created VM instances are not accessible via web interface and get lost on VM shutdown
* Benchmark definition requires Chef cookbook

## Things you may want to cover

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
