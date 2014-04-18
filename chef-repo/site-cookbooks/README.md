# Purpose
This directory contains specific cookbooks for the cloud_benchmarking application and benchmarks.
"site-cookbooks" means specific for a certain application and is commonly used in the Chef community.


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

1. Update `metadata.rb` with the cookbook specific informations (e.g. dependencies)
2. Write your cookbook and make use of the resources provided out of the box: http://docs.opscode.com/chef/resources.html
  * Search the docs any time: http://docs.opscode.com/search.html