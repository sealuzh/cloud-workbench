# cloud-benchmarking-cookbook

Installs and configures the cloud benchmarking application.

## Supported Platforms

Only tested with Ubuntu 12.04 (64bit)

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cloud-benchmarking']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### cloud-benchmarking::default

Include `cloud-benchmarking` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[cloud-benchmarking]"
  ]
}
```

```ruby
chef.run_list = ['recipe[cloud-benchmarking']
```

## License and Authors

Author:: seal uzh (<joel.scheuner.dev@gmail.com>)
