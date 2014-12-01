# This may also be provided via data bag. But because a parameter passing mechanism
# between the cloud-benchmarking-server and Vagrant is required on per benchmark
# basis anyway this should be solved the same way.
# default["benchmark"]["server-ip"] = nil # No useful default value possible
default["benchmark"]["dir"] = "/usr/local/cloud-benchmark"

### System specific
default["benchmark"]["owner"] = "ubuntu"
default["benchmark"]["group"] = "ubuntu"

### Runner that handles nohup and I/O redirection
default["benchmark"]["redirect_io"] = "false" # May later change to true if the log files from VMs are considered
default["benchmark"]["start_runner"] = "start_runner.sh"
default["benchmark"]["stop_and_postprocess_runner"] = "stop_and_postprocess_runner.sh"

### Execution
default["benchmark"]["start"] = "start.sh"
default["benchmark"]["stop_and_postprocess"] = "stop_and_postprocess.sh"


### May be supported later
# Creates a shell script with the inline content provided
# default["benchmark"]["start"]["sh"] = nil
# default["benchmark"]["stop_and_postprocess"]["sh"] = nil

# Creates a ruby file and calls it from the shell script
# default["benchmark"]["start"]["ruby"] = nil
# default["benchmark"]["stop_and_postprocess"]["ruby"] = nil


### VM instance identification information
# IMPORTANT: Do not override these attributes manually unless you know what you are doing.
# These values will be dynamically resolved based on the provider config
default["benchmark"]["provider_name"] = ""
# Provider instance id used to identify the VM instance from the Cloud-WorkBench
default["benchmark"]["provider_instance_id"] = ""


### Supported providers
# Timeout for metadata query requests
default["benchmark"]["timeout"] = "2"

# Amazon EC2 Cloud (aws)
default["benchmark"]["providers"]["aws"]["name"] = "aws"
# Instance id used by Vagrant to identify a VM. Example: 'i-6dd73b2d'
default["benchmark"]["providers"]["aws"]["instance_id_request"] = "wget -q -T #{node["benchmark"]["timeout"]} -O - http://169.254.169.254/latest/meta-data/instance-id"

# Google Compute Engine (google)
default["benchmark"]["providers"]["google"]["name"] = "google"
default["benchmark"]["providers"]["google"]["instance_id_request"] = "curl 'http://metadata.google.internal/computeMetadata/v1/instance/attributes/vagrant_id' -H 'Metadata-Flavor: Google' --max-time=#{node["benchmark"]["timeout"]}"
