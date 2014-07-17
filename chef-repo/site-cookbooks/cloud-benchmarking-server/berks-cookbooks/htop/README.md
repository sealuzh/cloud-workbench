# chef-htop  [![Build Status](http://img.shields.io/travis-ci/phlipper/chef-htop.png)](https://travis-ci.org/phlipper/chef-htop)

## Description

Installs [htop](http://htop.sourceforge.net/) an interactive process viewer for Linux.


## Requirements

### Supported Platforms

The following platforms are supported by this cookbook, meaning that the recipes run on these platforms without error:

* Ubuntu
* Debian
* RedHat
* CentOS

_NOTE:_ On RedHat/CentOS, the RPM is downloaded from [RepoForge](http://pkgs.repoforge.org/htop/)

## Recipes

* `htop` - The default recipe.

## Usage

this cookbook installs htop if not present, and pulls updates if they are installed on the system.

## Attributes

* `node['htop']['version']` - Version of htop to install. Defaults to nil.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Contributors

Many thanks go to the following who have contributed to making this cookbook even better:

* **[@rpunt](https://github.com/rpunt)**
    * initial pull request with redhat/centos support
* **[@dwradcliffe](https://github.com/dwradcliffe)**
    * add version attribute
    * add tests
* **[@billmoritz](https://github.com/billmoritz)**
    * support `yum` cookbook v3


## License

**chef-htop**

* Freely distributable and licensed under the [MIT license](http://phlipper.mit-license.org/2011-2014/license.html).
* Copyright (c) 2011-2014 Phil Cohen (github@phlippers.net) [![endorse](http://api.coderwall.com/phlipper/endorsecount.png)](http://coderwall.com/phlipper)  [![Gittip](http://img.shields.io/gittip/phlipper.png)](https://www.gittip.com/phlipper/)
* http://phlippers.net/


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/phlipper/chef-htop/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

