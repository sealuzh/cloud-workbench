name             'sysbench'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures sysbench'
long_description 'Installs/Configures sysbench'
version          '0.2.0'

depends 'apt'

recipe  'sysbench::default', 'Installs and configures sysbench.'
recipe  'sysbench::install', 'Installs sysbench'
recipe  'sysbench::configure', 'Configures sysbench for usage with Cloud WorkBench'
