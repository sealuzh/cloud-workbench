# Cloud WorkBench (CWB)


## Requirements
* Git (1.9.2)
* [Vagrant (1.5.4)](https://www.vagrantup.com/downloads)
    * [vagrant-omnibus (1.3.1)](https://github.com/schisamo/vagrant-omnibus)
    * [vagrant-aws (0.4.1)](https://github.com/mitchellh/vagrant-aws)
        * For deployment in the Amazon EC2 Cloud
    * [[optional] vagrant-berkshelf (2.0.1 or 2.0.0rc3)](https://github.com/berkshelf/vagrant-berkshelf)
        * For development with staging and development environment. Be aware that this plugin may cause unexpected installation issues.
    * [[optional] vagrant-cachier (0.7.0)](https://github.com/fgrehm/vagrant-cachier)
        * For optimized local development with VirtualBox
* Ruby (2.1.1) for development and deployment
    * [Installation](https://www.ruby-lang.org/en/downloads/)
    * [Mac installation tutorial](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)
    * [Windows installer](http://rubyinstaller.org/)

1. Vagrant can be easily installed with the installer for your system from [https://www.vagrantup.com/downloads](https://www.vagrantup.com/downloads)
2. The Vagrant plugins can be installed with this one-liner:

```bash
vagrant plugin install vagrant-omnibus; vagrant plugin install vagrant-aws
```

## Initial Configuration

### Ruby Project
1. `cd $REPO_ROOT`
2. `bundle install --without production` to install all Ruby on Rails dependencies which may take a while
3. `knife help` should now be available

### AWS
1. Checkout the Git repository `https://bitbucket.org/sealuzh/cloud-benchmarking`
2. Provide the following environment variables for the Amazon EC2 Cloud configuration (used to launch the CWB Server and Chef Server):
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


## Installation and Configuration

1. `cd $REPO_ROOT/vagrant/aws-demo`
2. `vagrant up --provider=aws` WARNING: This will acquire 2 VMs in the Amazon EC2 cloud: one for the Chef Server and one for the CWB Server.  Make sure you terminate the VMs after usage in order to avoid unnecessary expenses.
3. Meanwhile, create an Amazon EC2 security groups called `cloud_benchmarking_web` that allows incomming and outgoing ssh (20), http (80), and https (433)
4. Update the configuration at `REPO_ROOT/chef-repo/secret/vagrant-aws-demo/config.yml.secret`
    1. Enter the AWS access and secret keys that CWB Server should use to acquire and release resources
    2. Enter the CHEF_SERVER_IP (find out via Amazon web interface)
    3. Choose db passwords
    4. Provide ssh keys you want to use for deployment later
5. Once the Chef Server completed provisioning (may take 5-10 minutes) with `INFO: Report handlers complete`, setup the Chef Server authentication:
    1. Go to https://CHEF_SERVER_IP and accept the self-signed certificate
    2. Login with the default username (`admin`) and password (`p@ssw0rd1`)
    3. Go to https://CHEF_SERVER_IP/clients/new and create a new client with the name `CWB Server` and enabled admin flag.
    4. Copy the private key and paste it into `REPO_ROOT/chef-repo/secret/vagrant-aws-demo/chef_client_key.pem`
    5. Restrict file permissions with `chmod 600 chef_client_key.pem`
    6. Go to https://CHEF_SERVER_IP/clients/chef-validator/edit, enable "Private Key", and "Save Client"
    7. Copy this private key and past it into `REPO_ROOT/chef-repo/secret/vagrant-aws-demo/chef_validator.pem`
6. Configure Chef knife tool
    1. Move `REPO_ROOT/chef-repo/secret/vagrant-aws-demo/knife.rb` to `~/.chef/knife.rb`
    2. Update CHEF_SERVER_IP and REPO_ROOT within this file
    3. Check settings with a command like `knife node list` (returns empty list yet)
7. Configure CWB Server IP on Chef Server (alternatively via web interface)
    1. Create data bag with `knife data bag create benchmark`
    2. `cd REPO_ROOT/chef-repo/data_bags/benchmark`
    3. Update the `CWB_SERVER_IP` in `workbench_server.json`
    4. Upload data bag item with `knife data bag from file benchmark workbench_server.json`
8. Upload cookbooks to Chef Server (alternatively with knife cookbook upload)
    1. `cd REPO_ROOT/chef-repo/site-cookbooks/fio-benchmark`
    2. `berks install` resolves and downloads all dependencies
    3. `berks upload` uploads all cookbooks to the Chef Server
9. Once the CWB Server completed provisioning (may take 30-50 minutes depending on the chosen instance!), reprovision with `vagrant provision` (may take 2-10 minutes).
10. Deploy Rails application (see below)


#### CWB Server

Supported systems:

* Ubuntu 12.04
* Ubuntu 13.10

Note Ubuntu 14.04 has some issues with the postgres cookbook and requires some work to fix this. Other systems have not been tested.

* Use the Cookbook attributes to configure the CWB Server


## Deployment

Requires a Ruby on Rails development environment and checkout of the project. Make sure you have run `bundle install --without production chef`.

### Initial configuration
1. Ensure you have added your private key to your ssh-agent. For more information see https://help.github.com/articles/using-ssh-agent-forwarding.
2. Ensure you have added the corresponding public key to the config in `REPO_ROOT/chef-repo/secret/vagrant-aws-demo/config.yml.secret`
3. If you are not using `~/.ssh/id_rsa`, update "ssh_options" accordingly in `REPO_ROOT/config/deploy/demo.rb`
4. Check your settings with `bundle exec cap demo deploy:check`

### Deploy

Simply deploy new releases with `bundle exec cap demo deploy` (may take 20 minutes for the first time)

WARNING: This will restart the background job workers and should fail if there are currently running jobs.
Worker restart can be avoided by setting the live variable to true or passing it like `bundle exec cap demo deploy live=true`.
This is especially useful for GUI only updates

NOTE: Active schedules will be temporarily disabled during deployment.


## Reconfiguration on IP Address Change

### Chef Server

* CWB Server configuration
    1. `vim REPO_ROOT/chef-repo/secret/vagrant-aws-demo/config.yml.secret`
    2. Update the Chef Server IP
    3. `cd REPO_ROOT/vagrant/aws-demo`
    4. `vagrant provision cwb_server` to apply the changes (make sure you have set the `APPLY_SECRET_CONFIG` flag to true in the Vagrantfile)
* Workstation knife.rb
    1. `vim $HOME/.chef/knife.rb`
    2. Update the IP address of the Chef Server here

For more information about the Chef Server see:  http://docs.opscode.com/chef/manage_server_open_source.html

### CWB Server

* Data bag item on Chef Server
    * Command line
        1. `cd REPO_ROOT/vagrant/aws-demo`
        2. `vagrant provision chef_server` in order to reconfigure IP address
        3. `cd REPO_ROOT/chef-repo/data_bags/benchmark`
        4. Update the `CWB_SERVER_IP` in `workbench_server.json`
        5. Upload data bag item with `knife data bag from file benchmark workbench_server.json`
    * Web interface (alternative)
        1. `https://$CHEF_SERVER_IP/databags/benchmark/databag_items/workbench_server`
        2. Enter the IP address of the CWB Server here
* Capistrano deployment config (only for deployment)
    1. `vim $REPO_ROOT/config/deploy/demo.rb`
    2. Enter the IP address of the CWB Server here


## Manage CWB Server

Capistrano tasks can be used to easily conduct management tasks from the workstation on the CWB Server.

### Configuration

* Ensure you are in the root directory `cd REPO_ROOT`
* Ensure that the IP address of the CWB Server is configured in `REPO_ROOT/config/deploy/demo.rb`

### Tasks

Print a list of all tasks including their description with `cap -T`

Always include the environment e.g. `cap demo TASK_NAME`

#### Custom

* `cap demo user:change[password]` Change the password for the default user: 'cap demo user:change[new_password]'
* `cap demo rake[command]` Invoke a rake command on the remote app server: 'cap production rake[about]'
* `cap demo cron:clean` Clean system crontab
* `cap demo cron:update` Reflect the Cron schedules from database in system cron
* `cap demo worker:status_all` status_all delayed_job workers
* `cap demo worker:restart_all` restart_all delayed_job workers
* `cap demo worker:down_all` down_all delayed_job workers
* `cap demo worker:up_all` up_all delayed_job workers


#### Default

* `cap demo deploy` Deploy a new release
* `cap demo deploy:check` Check required files and directories exist
* `cap demo deploy:start` Start application, workers, and scheduler
* `cap demo deploy:stop` Stop scheduler, workers, and application


## Defining new Benchmarks

### Getting Started

1. Create a Cookbook that installs your benchmarks or use a VM image wherein your benchmark is already installed.
    * See the README.md in chef-repo/site-cookbooks for more information about how to get started with creating a cookbook.
    * Chef resources docs: http://docs.opscode.com/chef/resources.html
2. Upload the Cookbook with [`knife cookbook upload`](http://docs.opscode.com/knife_cookbook.html#upload) or [`berks upload`](http://berkshelf.com/) to the Chef-Server
3. Create a new Benchmark-Definition with the web interface of Cloud WorkBench under `BENCHMARK > Definitions > Create New Benchmark`
4. Create a metric definition for the new benchmark
5. Configure your Benchmark within the Vagranfile (e.g. region, vm image, instance type,) and add your Chef recipe via `chef.add_recipe "recipe[fio@0.1.0]"` (The @version is optional)
6. Start or schedule the benchmark via the CWB web interface.


### Hooks

The following hooks are available at `node["benchmark"]["dir"]` which currently defaults to `/usr/local/cloud-benchmark`:

* `start.sh` (required)
    * Invoked to start the benchmark
* `stop_and_postprocess.sh`
    * Invoked after `notify_benchmark_completed_and_wait` has been called

### Benchmark Helper (Client-side utility)

The benchmark helper is the client-side utility to manage the execution of a benchmark.

#### Notifications

* `notify_benchmark_completed_and_continue(success = true, message = '')`
    * Immediately continue with postprocessing.
    * success: Indicate whether the benchmark has been run sucessfully or failed (e.g. true or false). Submitting false will release the acquired resources.
    * message: Optional message (e.g. error log)
* `notify_benchmark_completed_and_wait(success = true, message = '')`
   * Do not continue with postprocessing. The Cloud WorkBench will ssh into the primary VM instance and start the prostprocessing.
    * success: Indicate whether the benchmark has been run sucessfully or failed (e.g. true or false). Submitting false will release the acquired resources.
    * message: Optional message (e.g. error log)
* `notify_postprocessing_completed(success = true, message = '', opts = {})`
    * The Cloud WorkBench will release the acquired resources.
    * success: Indicate whether the postprocessing has been completed successfully or failed (e.g. true or false) 
    * message: Optional message (e.g. error log)
    * opts: Not used yet

#### Metric submission

* `submit_metric(metric_definition_id, time, value)`
    * Submit a single metric to the Cloud WorkBench
    * metric_definition_id: The unique id (e.g. 12) or the name (e.g. seq. write) of the metric definition
    * time: An integer time for 2D metrics (e.g. 500)
    * value: The value of the metric (e.g. 1142)
* `submit_metrics(metric_definition_id, csv_file)`
    * Bulk submit multiple metrics for the same metric definition
    * csv_file: path to a csv file with 2 columns without header. Format: `[time],[value]` Example: `501,1373`

## Tests

Run the tests with `bundle exec rake` or `bundle exec rspec spec/`


### Guard and Spork

Start Guard and Spork with `bundle exec guard`.
This will preload the testing environment once and automatically execute the affected tests when files have been modified. Manually run all test with `all` in the interactive Spork console.

Automatic page reload on file change is supported for Safari, Chrome and Firefox via plugin from http://feedback.livereload.com/knowledgebase/articles/86242-how-do-i-install-and-use-the-browser-extensions-


### Slow tests

Test tagged as slow are excluded from being run by default. Explicitly run them via `rspec --tag slow spec/`

Tests can be tagged as slow by passing the :slow symbol
```ruby
describe 'a tagged test', :slow do
  it 'does some complex calculations' do
    expect(Universe.answer).to eq(42)
  end
end
```
Example from http://engineering.sharethrough.com/blog/2013/08/10/greater-test-control-with-rspecs-tag-filters/


## Limitations

* No technical user authentication and authorization (VMs can interact with CWB without authentication)
* Chef cookbooks must be uploaded to the Chef server
* Log files from created VM instances are not accessible via web interface and get lost on VM shutdown


## Manual Installation

NOTE: The manual installation is not recommendend and has not been tested. The requirements listed below are probably not complete.


### Requirements

* UNIX like system (only tested with Ubuntu)
* Git (1.7.9.5)
* Ruby 2.1.1 (rbenv version manager used in automated installation)
* NGINX
* Unicorn
* Nodejs
* PostgreSQL 9.1.13
    * Default table name: `cloud_benchmarking_production`
* Vagrant 1.5.3 with plugins
    * vagrant-aws 0.4.1
    * vagrant-omnibus 1.4.1
* cron
* runit (init scheme with service supervision)
    * NGINX
    * Unicorn
    * delayed_job background worker
* runit environment variable configuration depending on process
    * `BUNDLE_GEMFILE` := path to the Gemfile of the current release
    * `BUNDLE_PATH` := path to shared/vendor/bundle
    * `EXECJS_RUNTIME=Node`
    * `RAILS_ENV=production`
    * `HOME=/home/apps`
* svlogd [optional]
* Deployment directory in /home/apps/cloud_benchmarking
* User and group `apps`
* User and group `deploy` with root privileges and ssh configuration for deployment