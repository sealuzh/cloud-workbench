# benchmark-cookbook

Provides utilities for virtual machines (VMs) that execute benchmarks

## Supported Platforms

Tested on the following platforms:

* Ubuntu 12.04 64 bit
* Ubuntu 13.10 64 bit

## Attributes

See comments in /attributes/default.rb


## Usage

### benchmark::default

Include `benchmark` in your node's `run_list`:

You may specify a specific version with recipe[benchmark@0.2.0]"

```json
{
  "run_list": [
    "recipe[benchmark::default]"
  ]
}
```

```ruby
config.vm.provision "chef_client" do |chef|
  chef.add_recipe "benchmark"
end
```


## License and Authors

Author:: seal uzh (<joel.scheuner.dev@gmail.com>)
