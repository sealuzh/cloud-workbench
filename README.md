# Cloud WorkBench (CWB)

## Installation (automated)

### Requirements
* Git (1.9.2)
* [Vagrant (1.5.4)](https://www.vagrantup.com/downloads)
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
vagrant plugin install vagrant-omnibus; vagrant plugin install vagrant-aws
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

Supported systems:

* Ubuntu 12.04
* Ubuntu 13.10

Note Ubuntu 14.04 has some issues with the postgres cookbook and requirs some work to fix this. Other systems have not been tested.

#### Configure WorkBench Server

* Use the Cookbook attributes to configure the CWB-server

### Install Chef Server

1. `cd $GIT_REPO_HOME/cloud_benchmarking/chef-repo/site-cookbooks/cbench-chef-server/vagrant-aws-production`
2. `vagrant up --provider=aws`


## Installation (manual)

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


## Reconfiguration on IP address change

### CWB-Server

* Data bag item in Chefserver
	1. `https://$CHEF_SERVER_IP/databags/benchmark/databag_items/workbench_server`
	2. Enter the IP address of the WorkBench here
* Capistrano deployment config (only for deployment)
    1. `vim $GIT_REPO_HOME/cloud_benchmarking/config/deploy/production.rb`
    2. Enter the IP address of the WorkBench here


### Chef-Server

* WorkBench ~/.profile (automated)
    1. Enter the IP address of the Chef Server in the yaml config file at `chef-repo/secret/vagrant-aws-production` (Example for production environment)
    2. Set the `APPLY_SECRET_CONFIG` to true in the Vagrantfile. Make sure you also provide the chef_client_key.pem, chef_validator.pem and cloud-benchmarking.pem in the secret config
    3. Run `vagrant provision` in order to apply the new configuration
* WorkBench ~/.profile (manual)
    1. `cd $GIT_REPO_HOME/cloud_benchmarking/chef-repo/site-cookbooks/cloud-benchmarking-server/vagrant-aws-production`
    2. `vagrant ssh`
    3. `sudo vim /home/apps/.profile`
    4. Enter the IP address of the Chef Server here
* Workstation knife.rb
    1. `vim $HOME/.chef/knife.rb`
    2. Enter the IP address of the Chef Server here


## Deployment

Requires a Ruby on Rails development environment and checkout of the project. Make sure you have run `bundle install --without production chef`.

### Initial configuration
1. Ensure you have added your private key to your ssh-agent. For more information see https://help.github.com/articles/using-ssh-agent-forwarding.
2. Check your settings with `bundle exec cap production deploy:check`

### Deploy

Simply deploy new releases with `bundle exec cap production deploy`

WARNING: This will restart the background job workers and should fail if there are currently running jobs.
Worker restart can be avoided by setting the live variable to true or passing it like `bundle exec cap production deploy live=true`.
This is especially useful for GUI only updates

NOTE: Active schedules will be temporarily disabled during deployment.


## Benchmarks

### Getting Started

1. Create a Cookbook that installs your benchmarks or use a VM image wherein your benchmark is already installed.
    * See the README.md in chef-repo/site-cookbooks for more information about how to get started with creating a cookbook.
    * Chef resources docs: http://docs.opscode.com/chef/resources.html
2. Upload the Cookbook with [`knife cookbook upload`](http://docs.opscode.com/knife_cookbook.html#upload) or [`berks upload`](http://berkshelf.com/) to the Chef-Server
3. Create a new Benchmark-Definition with the web interface of Cloud WorkBench under `BENCHMARK > Definitions > Create New Benchmark`
4. Create a metric definition for the new benchmark
5. Configure your Benchmark within the Vagranfile (e.g. region, vm image, instance type,) and add your Chef recipe via `chef.add_recipe "recipe[fio@0.1.0]"` (The @version is optional)
6. Start or schedule the benchmark via the Cloud WorkBench web interface.


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
    * csv_file: path to a csv file with 2 columns without header. (1st: time) (2nd: value)

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

* No user authentication and authorization (also technical user)
* Chef cookbooks must be uploaded to the Chef server
* Log files from created VM instances are not accessible via web interface and get lost on VM shutdown
