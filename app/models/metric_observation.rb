class MetricObservation < ActiveRecord::Base
  belongs_to :metric_definition
  validates :metric_definition_id, presence: true
  belongs_to :benchmark_execution
end
