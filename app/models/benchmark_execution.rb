class BenchmarkExecution < ActiveRecord::Base
  belongs_to :benchmark_definition
  has_many :metric_observations
  has_many :virtual_machine_instances
end
