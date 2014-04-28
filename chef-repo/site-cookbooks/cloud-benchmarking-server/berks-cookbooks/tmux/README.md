tmux Cookbook
=============
[![Build Status](https://secure.travis-ci.org/opscode-cookbooks/tmux.png?branch=master)](http://travis-ci.org/opscode-cookbooks/tmux)

Installs tmux, a terminal multiplexer.


Requirements
------------
Platform with a package named 'tmux'. Does a source install on RHEL family.


Attributes
----------
- `node['tmux']['install_method']` - source or package, uses the appropriate recipe.
- `node['tmux']['version']` - version of tmux to download and install from source.
- `node['tmux']['checksum']` - sha256 checksum of the tmux tarball
- `node['tmux']['configure_options']` - array of command line options passed as arguments to the configure script when installing from source.


Usage
-----
Use the recipe for the installation method you want to use, or set the attribute on the node to install from that recipe and use the default recipe. The default recipe also manages `/etc/tmux.conf`.

On RHEL family, `node['tmux']['install_method']` is set to source by default. To install from package, the `yum::epel` recipe is required to get the tmux package, and the attribte would need to be set explicitly.

When installing from source, an install prefix can be set with the `configure_options` attribute. For example:

```ruby
default['tmux']['configure_options'] << "--prefix=/opt/tmux"
```

There are two "private" recipes, `_package`, and `_source` that are not meant to be included directly in a run_list. They are used by the default recipe and toggled with the node attribute `install_method`.


Development
-----------
This section details "quick development" steps. For a detailed explanation, see [[Contributing.md]].

1. Clone this repository from GitHub:

        $ git clone git@github.com:opscode-cookbooks/tmux.git

2. Create a git branch

        $ git checkout -b my_bug_fix

3. Install dependencies:

        $ bundle install

4. Make your changes/patches/fixes, committing appropiately
5. **Write tests**
6. Run the tests:
    - `bundle exec foodcritic -f any .`
    - `bundle exec rspec`
    - `bundle exec rubocop`
    - `bundle exec kitchen test`

  In detail:
    - Foodcritic will catch any Chef-specific style errors
    - RSpec will run the unit tests
    - Rubocop will check for Ruby-specific style errors
    - Test Kitchen will run and converge the recipes


License & Authors
-----------------
- Author: Joshua Timberman (<joshua@opscode.com>)

```text
Copyright: 2009-2012, Opscode, Inc. (<legal@opscode.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
