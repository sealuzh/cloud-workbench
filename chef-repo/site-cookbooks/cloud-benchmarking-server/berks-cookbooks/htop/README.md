# chef-htop

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


## License

**chef-htop**

* Freely distributable and licensed under the [MIT license](http://phlipper.mit-license.org/2011-2013/license.html).
* Copyright (c) 2011-2013 Phil Cohen (github@phlippers.net) [![endorse](http://api.coderwall.com/phlipper/endorsecount.png)](http://coderwall.com/phlipper)
* http://phlippers.net/
