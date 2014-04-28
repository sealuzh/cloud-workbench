tmux Cookbook CHANGELOG
=======================
This file is used to list changes made in each version of the tmux cookbook.


v1.4.0
------
### Improvement
- **[COOK-3582](https://tickets.opscode.com/browse/COOK-3582)** - Add `install_prefix` and `configure_opts` attributes
- **[COOK-3556](https://tickets.opscode.com/browse/COOK-3556)** - Add Test Kitchen 1.0, ChefSpec, Rubocop


v1.3.2
------
### Improvement
- **[COOK-3364](https://tickets.opscode.com/browse/COOK-3364)** - Use tmux 1.8 for source installations

v1.3.0
------
### Improvement
- [COOK-2547]: Add more options to tmux.conf template

v1.2.2
------
The repository didn't have pushed commits, and so the following changes from earlier-than-latest versions wouldn't be available on the community site. We're releasing 1.2.2 to correct this.

- [COOK-1841] - recipe downloads tmux tar everytime, even if its installed

v1.2.0
------
- [COOK-1649] - Typo in tmux default attributes
- [COOK-1652] - Missing deps for building tmux on centos
- [COOK-1756] - Allow tmux to be installed via source or package based on attribute

v1.1.2
------
- [COOK-1841] - recipe downloads tmux tar everytime, even if its installed

v1.1.0
------
- Added test-kitchen support

v1.0.1
------
- Add test kitchen support (test directory not included in release to community site)
- [COOK-1366] - default config template, TravisCI and CentOS support

v1.0.0
------
- Initial Release
