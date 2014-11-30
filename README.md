# Cloud WorkBench (CWB)


## Requirements
* [Git](http://git-scm.com/)
* [Vagrant (1.6.5)](https://www.vagrantup.com/downloads)
    * [vagrant-omnibus (1.4.1)](https://github.com/schisamo/vagrant-omnibus)
    * [vagrant-aws (0.5.0)](https://github.com/mitchellh/vagrant-aws) for deployment in the Amazon EC2 Cloud
* Ruby (2.1.1) for development and deployment
    * [Installation](https://www.ruby-lang.org/en/downloads/)
    * [Mac installation tutorial](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)
    * [Windows installer](http://rubyinstaller.org/)
* Amazon EC2 or Openstack cloud account. CWB can be automatically installed on two VMs that must have a public IP address.
    * Ensure that incoming and outgoing traffic is allowed for ssh (20), http (80), and https (433). In Amazon EC2, you can create a [security group](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html) `cwb_web`.

1. Vagrant can be easily installed with the installer for your system from [https://www.vagrantup.com/downloads](https://www.vagrantup.com/downloads)
2. The Vagrant plugins can be installed with this one-liner:

```bash
vagrant plugin install vagrant-omnibus; vagrant plugin install vagrant-aws;
# Only for Openstack Cloud Deployment
vagrant plugin install vagrant-openstack-plugin
```


## Initial Installation and Configuration
1. Checkout repository and install Ruby dependencies for administration tasks.

    ```bash
    git clone https://github.com/sealuzh/cloud-workbench; cd cloud-workbench; bundle install --gemfile=Gemfile_Admin;
    # Check knife installation
    knife help
    ```

2. Navigate into the appropriate install directory.

    ```bash
    cd install/aws          # Amazon EC2 Cloud
    cd install/openstack    # Openstack Cloud
    cd install/virtualbox   # Virtualbox (only for development/testing because public IP configuration is not supported yet)
    ```

3. Complete the configurations in `Vagrantfile` and `config.yml.secret`.
4. Start automated installation and configuration.
WARNING: This will acquire 2 VMs your configured cloud: one for the Chef Server and one for the CWB Server. Make sure you terminate the VMs after usage in order to avoid unnecessary expenses.

    ```bash
    vagrant up --provider=aws          # Amazon EC2 Cloud
    vagrant up --provider=openstack    # Openstack Cloud
    vagrant up`                        # Virtualbox (default provider)
    ```

5. Update the CHEF_SERVER_IP in `config.yml.secret` by filling in the public IP address of your cloud provider (e.g. find out via the Amazon web interface).
6. Once the Chef Server completed provisioning (may take 5-10 minutes) with `INFO: Report handlers complete`, setup the Chef Server authentication:
    1. Go to `https://CHEF_SERVER_IP` and accept the self-signed certificate
    2. Login with the default username (`admin`) and password (`p@ssw0rd1`). You might want to change the default password immediately.
    3. Go to `https://CHEF_SERVER_IP/clients/new` and create a new client with the name `cwb-server` and enabled admin flag.
    4. Copy the generated private key and paste it into `chef_client_key.pem`
    5. Restrict file permissions with:

        ```bash
        chmod 600 chef_client_key.pem
        ```

    6. Go to `https://CHEF_SERVER_IP/clients/chef-validator/edit`, enable "Private Key", and click "Save Client"
    7. Copy this private key and paste it into `chef_validator.pem`
6. Configure Chef `knife` and Berkshelf `berks` tools
    1. Move `knife.rb` to `~/.chef/knife.rb` and `config.json` to `~/.berkshelf/config.json`

        ```bash
        mkdir ~/.berkshelf; mkdir ~/.chef; mv config.json ~/.berkshelf/config.json; mv knife.rb ~/.chef/knife.rb;
        ```

    2. Update `CHEF_SERVER_IP` and `REPO_ROOT` within this file
    3. The following command should work now:

        ```bash
        knife node list
        ```

7. Configure the IP address of the CWB Server on the Chef Server (alternatively via the Chef server web interface)

    ```bash
    knife data bag create benchmark
    cd ../chef-repo/data_bags/benchmark
    # Update the `CWB_SERVER_IP` in `workbench_server.json`
    # Upload data bag item with:
    knife data bag from file benchmark workbench_server.json
    ```

8. Upload cookbooks to the Chef Server (alternatively with knife cookbook upload)

    ```bash
    cd ../../site-cookbooks/fio-benchmark; berks install; berks upload;
    ```

9. Once the CWB Server completed provisioning (may take 30-50 minutes depending on the chosen instance!), reprovision with `vagrant provision` (may take 2-10 minutes).
10. Deploy Rails application (see below)


## Deployment

Requires a Ruby on Rails development environment and checkout of the project. Make sure you completed step 1 of the `Initial Installation and Configuration` section.

### Initial configuration (for private repositories only)
1. Ensure you have added your private key to your ssh-agent for secure remote git checkout. For more information see https://help.github.com/articles/using-ssh-agent-forwarding.
    1. Allow agent forwarding in `~/.ssh/config`
    2. Make sure you have added your ssh key to the agent with `ssh-add path/to/your/private-ssh-key`
    3. Check whether your key is added with `ssh-add -L`
2. Ensure you have added the corresponding public key to the config in `install/${YOUR_PROVIDER}/config.yml.secret`
3. If you are not using `~/.ssh/id_rsa`, update "ssh_options" accordingly in `${REPO_ROOT}/config/deploy/demo.rb`
4. Check your settings with `bundle exec cap production deploy:check`

### Deploy

Simply deploy new releases with: (may take 20 minutes for the first time)

```bash
bundle exec cap production deploy
```

NOTE: This will restart the background job workers and should fail if there are currently running jobs.
Worker restarts can be avoided by setting a variable in the deploy config `set(:live, true) ` or passing it with `bundle exec cap production deploy live=true`.
This is especially useful for GUI only updates

NOTE: Active schedules will be temporarily (for a very short time) disabled during deployment.


## Manage VMs
Further documentation of the Vagrant CLI: https://docs.vagrantup.com/v2/cli/index.html

Bring up VMs: Starts or acquires 2 VMs and installs `cwb_server` and `chef_server`. Alternative providers are `openstack` or `virtualbox` (default).

```bash
vagrant up --provider=aws
vagrant up cwb_server --provider=aws
vagrant up chef_server --provider=aws
```

SSH into a VM (default: cwb_server)

```bash
vagrant ssh
vagrant ssh chef_server
```

Provision VMs (default: both)

```bash
vagrant provision
vagrant provision cwb_server
vagrant provision chef_server
```

Halt VMs (default: both)

```bash
vagrant halt
vagrant halt cwb_server
vagrant halt chef_server

```

Destroy VMs (default: both)

```bash
vagrant destroy
vagrant destroy cwb_server
vagrant destroy chef_server
```

## Reconfiguration on IP Address Change

### Chef Server

* CWB Server configuration
    1. `cd ${REPO_ROOT}/${YOUR_PROVIDER}`
    2. `vim config.yml.secret`
    3. Update the Chef Server IP
    4. `vagrant provision cwb_server` to apply the changes (make sure you have set the `APPLY_SECRET_CONFIG` flag to true in the Vagrantfile)
* Workstation knife.rb
    1. `vim $HOME/.chef/knife.rb`
    2. Update the IP address of the Chef Server here

For more information about the Chef Server see:  http://docs.opscode.com/chef/manage_server_open_source.html

### CWB Server

* Data bag item on Chef Server
    * Command line
        1. `cd $REPO_ROOT/$YOUR_PROVIDER`
        2. `vagrant provision chef_server` in order to reconfigure IP address
        3. `cd $REPO_ROOT/chef-repo/data_bags/benchmark`
        4. Update the `CWB_SERVER_IP` in `workbench_server.json`
        5. Upload data bag item with `knife data bag from file benchmark workbench_server.json`
    * Web interface (alternative)
        1. `https://$CHEF_SERVER_IP/databags/benchmark/databag_items/workbench_server`
        2. Enter the IP address of the CWB Server here
* Capistrano deployment config (only for deployment)
    1. `vim $REPO_ROOT/config/deploy/production.rb`
    2. Enter the IP address of the CWB Server here


## Manage CWB Server

Capistrano tasks can be used to easily conduct management tasks from the workstation on the CWB Server.

### Configuration

* Ensure you are in the root directory `cd REPO_ROOT`
* Ensure that the IP address of the CWB Server is configured in `REPO_ROOT/config/deploy/production.rb`

### Tasks

Print a list of all tasks including their description with `cap -T`

Always include the environment e.g. `cap production TASK_NAME`

#### Custom

* `cap production user:change[password]` Change the password for the default user: 'cap production user:change[new_password]'
* `cap production rake[command]` Invoke a rake command on the remote app server: 'cap production rake[about]'
* `cap production cron:clean` Clean system crontab
* `cap production cron:update` Reflect the Cron schedules from database in system cron
* `cap production worker:status_all` status_all delayed_job workers
* `cap production worker:restart_all` restart_all delayed_job workers
* `cap production worker:down_all` down_all delayed_job workers
* `cap production worker:up_all` up_all delayed_job workers


#### Default

* `cap production deploy` Deploy a new release
* `cap production deploy:check` Check if required files and directories exist for deployment
* `cap production deploy:start` Start application, workers, and scheduler
* `cap production deploy:stop` Stop scheduler, workers, and application


## Defining new Benchmarks

### Getting Started

1. Create a Chef cookbook with [`knife cookbook create NAME`](http://docs.getchef.com/knife_cookbook.html#create) or [`berks cookbook NAME`](http://berkshelf.com/). Alternatively create a VM image wherein your benchmark is already installed.
    * See the README.md in chef-repo/site-cookbooks for more information about how to get started with creating a cookbook.
    * Chef resources docs: http://docs.opscode.com/chef/resources.html
2. Upload the Cookbook with [`knife cookbook upload`](http://docs.opscode.com/knife_cookbook.html#upload) or [`berks upload`](http://berkshelf.com/) to the Chef-Server
3. Create a new Benchmark-Definition with the web interface of Cloud WorkBench under `BENCHMARK > Definitions > Create New Benchmark`
4. Create a metric definition for the new benchmark
5. Configure your Benchmark within the Vagranfile (e.g. region, vm image, instance type,) and add your Chef recipe via `chef.add_recipe 'fio@0.1.0'` (The @version is optional)
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



## Development


### Tests

Run the tests with `bundle exec rake` or `bundle exec rspec spec/`


#### Guard and Spork

Start Guard and Spork with `bundle exec guard`.
This will preload the testing environment once and automatically execute the affected tests when files have been modified. Manually run all test with `all` in the interactive Spork console.

Automatic page reload on file change is supported for Safari, Chrome and Firefox via plugin from http://feedback.livereload.com/knowledgebase/articles/86242-how-do-i-install-and-use-the-browser-extensions-


#### Slow tests

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


### Development Environment

For development and testing purpose, CWB can be locally installed into 2 Virtualbox VMs in an automated manner (see $REPO_ROOT/virtualbox directory). However, due to missing public IP configurations, CWB does not work properly (i.e. results cannot be submitted). Make sure you have installed [Virtualbox](https://www.virtualbox.org/wiki/Downloads).

The Vagrant plugin [vagrant-cachier (1.1.0)](https://github.com/fgrehm/vagrant-cachier) can speed up development by serving as a cache for chef, apt, gem, etc.

```bash
vagrant plugin install vagrant-cachier
```

## Limitations

* No technical user authentication and authorization (VMs can interact with CWB without authentication)
* Chef cookbooks must be uploaded to the Chef server
* Log files from created VM instances are not accessible via web interface and get lost on VM shutdown


## Manual Installation

NOTE: The manual installation is not recommended and has not been tested. The requirements listed below may be incomplete.


### Requirements

* UNIX like system (only tested with Ubuntu)
* Git
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
