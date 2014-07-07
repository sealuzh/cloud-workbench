name             'www-micro-all'
maintainer       'seal uzh'
maintainer_email ''
license          'Apache 2.0'
description      'Installs/Configures www-micro-all'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'apt'
depends 'www-micro-cpu'
depends 'www-micro-mem'
depends 'www-micro-io'