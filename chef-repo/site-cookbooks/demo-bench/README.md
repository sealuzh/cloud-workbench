# demo-bench-cookbook

Installs and configures a simple cpu sysbench. Created for demonstration purpose.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['demo-bench']['cpu_max_prime']</tt></td>
    <td>Integer</td>
    <td>Command line argument of sysbench for cpu test</td>
    <td><tt>20000</tt></td>
  </tr>
</table>

## Usage

### demo-bench::default

Add `demo-bench` to your Chef `run_list`:

```ruby
chef.add_recipe "recipe[www-micro-cpu@0.1.0]"
```

Optionally configure the cli option `cpu-max-prime` via attribute:

```ruby
chef.json =
{
    'demo-bench' => {
        'cpu_max_prime' => '7000'
    }
}
```

## License and Authors

Author: seal uzh (<joel.scheuner.dev@gmail.com>)
