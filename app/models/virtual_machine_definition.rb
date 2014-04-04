class VirtualMachineDefinition < ActiveRecord::Base
  belongs_to :benchmark_definition
  belongs_to :cloud_provider
  validates :cloud_provider_id, presence: true
  has_many :virtual_machine_instances, dependent: :destroy
end
