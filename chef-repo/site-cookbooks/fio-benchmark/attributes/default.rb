# Installation
default[:fio][:version] = '2.1.8' # Most recent version in 2014-04-22
default[:fio][:install_method] = 'source' # Alternative is 'apt'
default[:fio][:source_url] = "http://brick.kernel.dk/snaps/fio-#{node[:fio][:version]}.tar.gz"
default[:fio][:bin] = 'fio'

# Benchmark definition
default[:fio][:metric_definition_id] = nil # MUST be provided

default[:fio][:rw] = 'write'
default[:fio][:size] = '10m'
default[:fio][:bs] = '4K-4K/4K-4K'
default[:fio][:write_bw_log] = 'fio_write_job' # generates "fio_write_job_bw.log"
default[:fio][:write_lat_log] = nil
default[:fio][:write_iops_log] = nil

# Configuration
default[:fio][:template_name] = 'fio_job.ini.erb'
default[:fio][:template_cookbook] = 'fio-benchmark'
default[:fio][:config_file] = 'fio_job.ini'

# Execution
# TODO: Support this shortcut
# default[:benchmark][:start][:sh] = "#{node[:fio][:bin]} #{node[:fio][:config_file]}"