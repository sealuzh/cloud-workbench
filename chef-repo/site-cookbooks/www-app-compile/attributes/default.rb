# Benchmark definition
default[:compile][:metric_definition_id] = nil # MUST be provided
default[:compile][:download_cmd] = "git clone https://github.com/xLeitix/jcloudscale.git"
default[:compile][:compile_cmd] = "cd jcloudscale && mvn clean package -DskipTests"
default[:compile][:cleanup_cmd] = "rm -fr ~/.m2 ; rm -fr jcloudscale"
default[:compile][:repetitions] = 3