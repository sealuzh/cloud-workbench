# Chef cookbook - appbox (v0.1.1)

Provides a set of recipes to setup a **base app server**:

 * create users and groups
 * setup base directory to store apps
 * install common sysadmin tools

## Install

To install with **Berkshelf**, add this into `Berksfile`:

```
cookbook 'appbox'
```

## Usage

To setup a base app server, 

Add `appbox::default` recipe into run list, or include the recipe in your code:

```
include_recipe "appbox::default"
```

And override attributes to customize the cookbook.

See also [teohm/kitchen-sample](https://github.com/teohm/kitchen-example) for `appbox` usage example with chef-solo.

## Attributes

You **should** set these attributes:

 * `node["appbox"]["admin_keys"]` (default: `[]`) - a list of authorized SSH public keys for admin user.
 * `node["appbox"]["deploy_keys"]` (defaults: `[]`) - a list of authorized SSH public keys for deploy user.

You may customize these attributes:

 * `node["appbox"]["admin_user"]` (default: `"devops"`) - admin account, to perform sysadmin tasks (login with SSH key, passwordless sudo, member of apps group). 
 * `node["appbox"]["deploy_user"]` (default: `"deploy"`) - deploy account, to deploy apps (login with SSH key, passwordless sudo, member of apps group).
 * `node["appbox"]["apps_user"]` (default: `"apps"`) - apps account, to run apps (no login, not sudoer, member of apps group).
 * `node["appbox"]["apps_dir"]` (default: `"/home/apps"`) - base directory to store apps, writable (with +SGID) by apps group members.

## Recipes

 * `appbox::default` - run all recipes.
 * `appbox::package_update` - update software packages (with `apt-get update`).
 * `appbox::users` - create users and groups.
 * `appbox::apps_dir` - setup base directory to store apps.
 * `appbox::tools` - install the following tools:
   * curl
   * htop
   * git
   * tmux

## Requirements

### Supported Platforms

 * `ubuntu` - tested on Ubuntu 12.10
 * `debian` - should work
 
Pull requests, issue and test reports are welcomed to better support your platform.
 
### Cookbook Dependencies

 * Depends on these cookbooks:
   * apt
   * sudo
   * user
   * curl
   * htop
   * git
   * tmux

## License and Authors

 * Author:: Huiming Teo <teohuiming@gmail.com>

Copyright 2013, Huiming Teo

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
