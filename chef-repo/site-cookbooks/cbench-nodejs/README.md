# cbench-nodejs-cookbook

Wrapper cookbook for the nodejs cookbook.
Fixes the issue that nodejs gets rebuild from source on every Chef client run.
Uses the pull request submitted on Github (but not merged yet 2014-04-20)  https://github.com/mdxp/nodejs-cookbook/pull/36

## Supported Platforms

See nodejs

## Attributes

See nodejs

## Usage

### cbench-nodejs::default

Include `cbench-nodejs` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[cbench-nodejs::default]"
  ]
}
```

## License and Authors

Author:: seal uzh (<joel.scheuner.dev@gmail.com>)
