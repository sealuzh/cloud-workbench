class BenchmarkExecution < ActiveRecord::Base
  belongs_to :benchmark_definition
  validates :benchmark_definition, presence: true
  has_many :nominal_metric_observations
  has_many :virtual_machine_instances
end
