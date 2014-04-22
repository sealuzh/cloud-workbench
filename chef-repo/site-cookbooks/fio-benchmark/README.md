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
    <td><tt>[:fio][:version]</tt></td>
    <td>String</td>
    <td>Version of FIO</td>
    <td><tt>2.1.8</tt></td>
  </tr>
  <tr>
    <td><tt>[:fio][:install_source_]</tt></td>
    <td>String</td>
    <td>Install from sources (true) or via apt (false)</td>
    <td><tt>true</tt></td>
  </tr>
</table>

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
      'version' => '1.99.5'
    }
  }

  chef.run_list = [
    'recipe[fio-benchmark::default]'
  ]
  ...
end
```

License and Authors
-------------------
Authors: Joel Scheuner
