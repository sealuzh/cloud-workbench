# cloud-benchmarking-server-cookbook

Installs and configures the server of the cloud benchmarking application.

Only unicorn and postgresql have been tested. Using passenger and mysql would require some tweaking.

## Supported Platforms

Only tested with Ubuntu 12.04 (64bit)

Known issues:
* For other platforms the vagrant cookbook must be reconfigured (url + checksum)

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cloud-benchmarking-server']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### cloud-benchmarking::default

Include `cloud-benchmarking-server` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[cloud-benchmarking-server]"
  ]
}
```

```ruby
chef.run_list = ['recipe[cloud-benchmarking-server']
```

## License and Authors

Author:: seal uzh (<joel.scheuner.dev@gmail.com>)
