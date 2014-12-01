name             'fio-benchmark'
maintainer       'Joel Scheuner'
maintainer_email 'joel.scheuner.dev@gmail.com'
license          'Apache 2.0'
description      'Installs and configures the fio-benchmark'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.1'

depends 'apt'
depends 'build-essential'

recipe  'fio-benchmark::default', 'Installs and configures the fio benchmark.'
recipe  'fio-benchmark::install_source', 'Installs the fio benchmark from source.'
recipe  'fio-benchmark::install_apt', 'Installs the fio benchmark via apt.'
recipe  'fio-benchmark::configure', 'Configures the fio benchmark via job file'