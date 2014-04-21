# This may also be provided via data bag. But since a parameter passing mechanism
# between the cloud-benchmarking-server and Vagrant is required on per benchmark
# basis anyway this should be solved the same way.
default["benchmark"]["server-ip"] = nil # No useful default value possible

# System specific
default["benchmark"]["owner"] = "ubuntu"
default["benchmark"]["group"] = "ubuntu"

# Runner that handle nohup and I/O redirection
default["benchmark"]["start_runner"] = "start_runner.sh"
default["benchmark"]["stop_and_postprocess_runner"] = "stop_and_postprocess_runner.sh"

# Execution
default["benchmark"]["start"] = "start.sh"
default["benchmark"]["stop_and_postprocess"] = "stop_and_postprocess.sh"

# May be supported later: Creates a shell script with the inline content provided
# default["benchmark"]["start"]["sh"] = nil
# default["benchmark"]["stop_and_postprocess"]["sh"] = nil

# May be supported later: Creates a ruby file and calls it from the shell script
# default["benchmark"]["start"]["ruby"] = nil
# default["benchmark"]["stop_and_postprocess"]["ruby"] = nil