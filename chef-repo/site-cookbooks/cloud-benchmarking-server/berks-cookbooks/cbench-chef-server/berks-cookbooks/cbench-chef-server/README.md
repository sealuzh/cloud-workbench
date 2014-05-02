# cbench-chef-server-cookbook

Wrapper cookbook for the chef-server cookbook from:
 
* Opscode: http://community.opscode.com/cookbooks/chef-server
* Github: https://github.com/opscode-cookbooks/chef-server

TODO: Find workaround for dynamic public ip/hostname detection that does not require the AWS metadata service as this is now used!!!

## Supported Platforms

See chef-server

## Attributes

See chef-server

## Usage

### Vagrant

#### Requirements

* Vagrant (1.5.4)
  * vagrant-omnibus (1.3.1)
  * vagrant-berkshelf (2.0.0.rc3)
  * [optional] vagrant-aws (0.4.1)

#### AWS

Create an instance and provision a chef-server with `vagrant up --provider=aws` within the vagrant-aws directory.

##### Requirements

The following environement variables must be defined:

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
The provided values are examples from AWS and do NOT work.

### cbench-chef-server::default

See chef-server


For detailed configuration options see `chef-server.rb` http://docs.opscode.com/config_rb_chef_server.html


## License and Authors

Author:: seal uzh (<joel.scheuner.dev@gmail.com>)
