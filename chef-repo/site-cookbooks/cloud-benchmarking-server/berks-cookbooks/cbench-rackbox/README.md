# cbench-rackbox-cookbook

Wrapper cookbook for the rackbox cookbook. Fixes an error where all web servers (unicorn and passenger) are installed regardless of the provided attributes. It also provides a custom runit template for unicorn and provides additional environment variables (BUNDLE_GEMFILE, BUNDLE_PATH) for the unicorn_runit setup (see libraries/helpers).

## Supported Platforms

See rackbox

## Attributes

See rackbox

## Usage

### cbench-rackbox::default

See rackbox


## License and Authors

Author:: seal uzh (<joel.scheuner.dev@gmail.com>)
