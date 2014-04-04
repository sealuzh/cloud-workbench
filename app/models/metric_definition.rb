class MetricDefinition < ActiveRecord::Base
  belongs_to :benchmark_definition
  has_many :metric_observations, dependent: :destroy
end
