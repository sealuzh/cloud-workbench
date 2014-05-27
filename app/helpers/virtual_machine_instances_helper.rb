module VirtualMachineInstancesHelper
  def confirm_delete_vm_instance_msg(vm_instance)
    { confirm: "This action will delete this execution and all its associated metric_observations." }
  end
end
