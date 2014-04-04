class VirtualMachineInstance < ActiveRecord::Base
  belongs_to :virtual_machine_definition
  validates :virtual_machine_definition_id, presence: true
  belongs_to :benchmark_execution, presence: true
end
