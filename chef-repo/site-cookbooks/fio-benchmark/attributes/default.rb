# Enable io redirect per default
# + easier for debugging
# * should not affect benchmark performance as no output is written to stdout during the benchmark
default["benchmark"]["redirect_io"] = "true"

# Installation
default['fio']['version'] = '2.1.10' # Most recent version in 2014-06-18
default['fio']['install_method'] = 'source' # Alternative is 'apt'
default['fio']['source_url'] = "http://brick.kernel.dk/snaps/fio-#{node['fio']['version']}.tar.gz"

# Benchmark definition
default['fio']['metric_definition_id'] = 'seq. write' # Ensure that this metric definition exits

## CLI options
default['fio']['cli_options'] = '' # Example: '--refill_buffers' to prevent SSD compression effect

## Configuration (format key=value)
# FIO variables available (see section 4.2): http://git.kernel.dk/?p=fio.git;a=blob;f=HOWTO;hb=HEAD
# $pagesize		The architecture page size of the running system
# $mb_memory	Megabytes of total memory in the system
# $ncpus		Number of online available CPUs
# Example usage: size=2*$mb_memory
default['fio']['config']['rw'] = 'write'
default['fio']['config']['size'] = '10m'
default['fio']['config']['bs'] = '4k'
default['fio']['config']['write_bw_log'] = 'fio_write_job' # Generates "fio_write_job_bw.log"
default['fio']['config']['direct'] = '1'
default['fio']['config']['ioengine'] = 'sync'
default['fio']['config']['refill_buffers'] = '0'

# Configuration template
default['fio']['template_name'] = 'fio_job.ini.erb'
default['fio']['template_cookbook'] = 'fio-benchmark'
default['fio']['config_file'] = 'fio_job.ini'
