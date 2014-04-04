class BenchmarkDefinition < ActiveRecord::Base
  has_many :metric_definitions
  has_many :virtual_machine_definitions
  has_many :benchmark_executions, dependent: :destroy
end
