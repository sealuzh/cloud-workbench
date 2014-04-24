# Purpose
This directory contains specific cookbooks for the cloud_benchmarking application and benchmarks.
"site-cookbooks" means specific for a certain application and is commonly used in the Chef community.


# Installation

Prerequisites:

* Chef configured with `$HOME/.chef/knife.rb` (server registration for cookbook upload required)

## Option A

Prefered option if you have a Ruby development environment installed with RVM or rbenv.

1. Make sure you have Ruby version 2.1.1 installed
2. `cd $GIT_REPO_HOME/cloud_benchmarking`
3. `bundle install --without=production:test`
4. `knife -v` and `berks -v` should be available

## Option B

Alternative if you have no Ruby development environment available but Vagrant installed.

1. `vagrant plugin install chef`
2. `knife -v` should be available but you might be required to use the full path `$HOME/.vagrant.d/gems/bin/knife`. Consider symlinking to your $PATH (e.g. `ln -s  $HOME/.vagrant.d/gems/bin/knife /usr/local/bin`) or using an alias in .profile `alias knife="$HOME/.vagrant.d/gems/bin/knife".

# Create cookbooks

## Berks (recommended)

`berks cookbook COOKBOOK`

Example: `berks cookbook cloud-benchmarking`

This will create the following directory structure:
.  
├── Berksfile  
├── Berksfile.lock  
├── CHANGELOG.md  
├── Gemfile  
├── Gemfile.lock  
├── LICENSE  
├── README.md  
├── Thorfile  
├── Vagrantfile  
├── attributes  
├── chefignore  
├── files  
│   └── default  
├── libraries  
├── metadata.rb  
├── providers  
├── recipes  
│   └── default.rb  
├── resources  
└── templates  
    └── default  

See docs: http://berkshelf.com/

Note: If you want to commit your cookbook to the seal Bitbucket repository make sure you delete the `.git/` repository that Berkshelf automatically creates for you with `cd GIT_REPO_HOME/cloud_benchmarking/chef-repo/site-cookbooks/COOKBOOK_NAME` and `rm -r .git/`


## Knife

`knife cookbook create COOKBOOK`

Example: `knife cookbook create cloud-benchmarking`

This will create the following directory structure:
.  
├── CHANGELOG.md  
├── README.md  
├── attributes  
├── definitions  
├── files  
│   └── default  
├── libraries  
├── metadata.rb  
├── providers  
├── recipes  
│   └── default.rb  
├── resources  
└── templates  
    └── default  

See docs: http://docs.opscode.com/knife_cookbook.html#create


# Next steps

1. Update `metadata.rb` and `README.md` with the cookbook specific informations (e.g. dependencies)
2. Write your cookbook and make use of the resources provided out of the box: http://docs.opscode.com/chef/resources.html
  * Search the docs any time: http://docs.opscode.com/search.html
3. Delete unnecessary files and directories