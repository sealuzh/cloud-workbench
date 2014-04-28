[![Build Status](https://travis-ci.org/retr0h/cookbook-curl.png?branch=master)](https://travis-ci.org/retr0h/cookbook-curl)
[![Dependency Status](https://gemnasium.com/retr0h/cookbook-curl.png)](https://gemnasium.com/retr0h/cookbook-curl)

Description
============

Installs/Configures curl

Requirements
============

* Chef 11

Attributes
==========

* `default['curl']['libcurl_packages']` - A list of libcurl packages to install.

Usage
=====

```json
"run_list": [
    "recipe[curl]"
]
```

default
-------

Installs/Configures curl

libcurl
-------

Install/Configure libcurl packages

Testing
=======

    $ rake

License and Author
==================

Author:: John Dewey (<john@dewey.ws>)

Copyright 2012-2014, John Dewey

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
