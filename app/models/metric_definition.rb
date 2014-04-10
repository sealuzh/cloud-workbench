class MetricDefinition < ActiveRecord::Base
  belongs_to :benchmark_definition
  has_many :nominal_metric_observations, dependent: :destroy
  has_many :ordered_metric_observations, dependent: :destroy
end
