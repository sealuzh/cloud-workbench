# Benchmark definition
default[:all][:metric_definition_id] = nil # MUST be provided
default[:all][:max_prime] = 20000
default[:all][:repetitions] = 3
default[:all][:threads] = 1
default[:all][:file_size] = "5G"
default[:all][:max_time] = 600
default[:all][:frame_size] = 64
default[:all][:bench_rep] = 50