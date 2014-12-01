fio-benchmark Cookbook
======================
Installs and configures the FIO benchmark. For more info about FIO see:
* Freecode: http://freecode.com/projects/fio
* Official website (repo only): http://git.kernel.dk/?p=fio.git;a=summary
* Github: https://github.com/axboe/fio
* 3rd party Wiki: http://www.thomas-krenn.com/en/wiki/Fio.


Requirements
------------

#### Tested with
* Ubuntu 12.04 LTS 64 bit
* Ubuntu 14.04 LTS 64 bit

#### packages
- apt: Update package list for build-essential installation
- build-essential: gcc required for benchmark compilation

Attributes
----------

#### fio-benchmark::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['fio']['version']</tt></td>
    <td>String</td>
    <td>Version of FIO. Only relevant for installation from source code.</td>
    <td><tt>2.1.10</tt></td>
  </tr>
  <tr>
    <td><tt>['fio']['install_method']</tt></td>
    <td>String</td>
    <td>Install either from source code (source) or via apt (apt).</td>
    <td><tt>source</tt></td>
  </tr>
</table>

=> See attributes/default.rb for more configuration options

Usage
-----
#### fio-benchmark::default

Include `fio-benchmark` in your node's `run_list` and optionally provide the version:

See http://git.kernel.dk/?p=fio.git;a=tags for the latest versions

Vagrant example:

```ruby
config.vm.provision "chef_client" do |chef|
  ...
  chef.json = {
    'fio' => {
      'version' => '1.99.5',
      'config' => {
        'size' => '100m'
      }
    }
  }

  # Version number is optional
  # Make sure the dependency to the 'benchmark' cookbook is fulfilled (automatically handled by CWB)
  chef.add_recipe 'fio-benchmark@0.3.0'
  ...
end
```

License and Authors
-------------------
Authors: Joel Scheuner
