name             'cloud-benchmarking-server'
maintainer       'seal uzh'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'Apache 2.0'
description      'Installs and configures the cloud-benchmarking server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.1'

depends 'vim'
depends 'apt'
depends 'build-essential'
# Customized cookbook loaded from local repo. Improved version of a Github fork of the original vagrant cookbook.
depends 'vagrant'
depends 'cbench-databox'
depends 'cbench-rackbox'
depends 'nodejs'
depends 'timezone-ii'
depends 'ntp'
