class MetricDefinition < ActiveRecord::Base
  extend Enumerize

  belongs_to :benchmark_definition
  has_many :nominal_metric_observations, dependent: :destroy
  has_many :ordered_metric_observations, dependent: :destroy

  enumerize :scale_type, in: [:nominal, :ordinal, :interval, :ratio], default: :ratio
  validates :name, presence: true, uniqueness: { scope: :benchmark_definition_id, case_sensitive: false }
end
