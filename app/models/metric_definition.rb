class MetricDefinition < ApplicationRecord
  extend Enumerize

  belongs_to :benchmark_definition
  has_many :nominal_metric_observations, dependent: :destroy
  has_many :ordered_metric_observations, dependent: :destroy

  enumerize :scale_type, in: [:nominal, :ordinal, :interval, :ratio], default: :nominal
  validates :name, presence: true, uniqueness: { scope: :benchmark_definition_id, case_sensitive: false }

  def has_any_observations?
    nominal_metric_observations.any? || ordered_metric_observations.any?
  end

  def create_observation!(time, value, vm_instance_id)
    if scale_type.nominal?
      nominal_metric_observations.create!(time: time, value: value, virtual_machine_instance_id: vm_instance_id)
    else
      ordered_metric_observations.create!(time: time, value: value, virtual_machine_instance_id: vm_instance_id)
    end
  end
end
