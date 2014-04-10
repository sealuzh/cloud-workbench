class AddVirtualMachineInstanceRefToNominalMetricObservation < ActiveRecord::Migration
  def change
    add_reference :nominal_metric_observations, :virtual_machine_instance, index: { name: 'index_nominal_metric_observations_on_vm_instance_id '}
  end
end
