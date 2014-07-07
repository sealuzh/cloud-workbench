# Benchmark definition
default[:cpu][:metric_definition_id] = nil # MUST be provided
default[:cpu][:max_prime] = 20000
default[:cpu][:repetitions] = 1
default[:cpu][:threads] = 1
default[:cpu][:run_every] = "1h"
default[:cpu][:run_for] = "3d"