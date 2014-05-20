Timezone II
===========

The Timezone II cookbook contains recipes for installing the latest tzdata
(a.k.a. IANA or Olson) timezone database and setting the timezone on your
system.  It is a fork of the [timezone cookbook by James
Harton.](http://community.opscode.com/cookbooks/timezone)

Requirements
------------

This cookbook is known to work with:

* Amazon Linux
* CentOS
* Debian
* Fedora
* Gentoo
* Ubuntu

It _should_ work with any OS that uses the IANA/Olson timezone database and
stores local timezone data in /etc/localtime (the only OS I know of that does
_not_ do this is MS Windows).  However, some OSs not mentioned above have their
own system utility for setting the timezone, and this may overwrite the changes
made by this cookbook.

Attributes
----------

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['tz']</tt></td>
    <td>String</td>
    <td>the timezone name as defined in tzdata</td>
    <td>UTC</td>
  </tr>
  <tr>
    <td><tt>['timezone']['tzdata_dir']</tt></td>
    <td>String</td>
    <td>the path to the root of the tzdata files; the default value is for
    most known distributions of Linux</td>
    <td>/usr/share/zoneinfo</td>
  </tr>
  <tr>
    <td><tt>['timezone']['localtime_path']</tt></td>
    <td>String</td>
    <td>the path to the file used by the kernel to read the local timezone's
    settings; the default works for Linux and other *ix variants</td>
    <td>/etc/localtime</td>
  </tr>
  <tr>
    <td><tt>['timezone']['use_symlink']</tt></td>
    <td>Boolean</td>
    <td>whether to use a symlink into the tzdata tree rather than make a copy
    of the appropriate timezone data file (linux-generic recipe only)</td>
    <td>false</td>
  </tr>
</table>

Usage
-----

Set the "tz" attribute to your desired timezone and include the "timezone-ii"
recipe in your node's run list:

```json
{
  "name": "my_node",
  "tz": "Africa/Timbuktu",
  "run_list": [
    "recipe[timezone-ii]"
  ]
}
```

The `timezone-ii::default` recipe will first install or upgrade the IANA/Olson
timezone database package for your OS (`timezone-data` on Gentoo, `tzdata` on
all others). Then it will call one of the following recipes according to your
node's platform:

* `timezone-ii::debian`
* `timezone-ii::fedora`
* `timezone-ii::linux-generic`

Contributing
------------
1. Fork the [repository on GitHub](https://github.com/L2G/timezone-ii)
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. If at all possible, write test-kitchen tests for your change and ensure they
   all pass
5. Submit a pull request using GitHub

License and Authors
-------------------

Copyright © 2010 James Harton <james@sociable.co.nz>

Copyright © 2013 Lawrence Leonard Gilbert <larry@L2G.to>

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License.  You may obtain a copy of the
License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See the License for the
specific language governing permissions and limitations under the License.
