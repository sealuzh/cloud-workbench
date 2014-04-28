# benchmark-cookbook

Provides utilities for virtual machines (VMs) that execute benchmarks

## Supported Platforms

Only tested on Ubuntu 12.04 64 bit

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['benchmark']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### benchmark::default

Include `benchmark` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[benchmark::default]"
  ]
}
```


## License and Authors

Author:: seal uzh (<joel.scheuner.dev@gmail.com>)
