class BenchmarkDefinition < ActiveRecord::Base
  has_many :metric_definitions
  has_many :virtual_machine_definitions
  has_many :benchmark_executions, dependent: :destroy
  # Notice: Uniqueness constraint may be violated by occurring race conditions with database adapters
  # that do not support case-sensitive indices.
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
