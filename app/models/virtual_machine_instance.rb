class VirtualMachineInstance < ActiveRecord::Base
  belongs_to :benchmark_execution
  validates :benchmark_execution, presence: true
  has_many :nominal_metric_observations
  has_many :ordered_metric_observations
end
