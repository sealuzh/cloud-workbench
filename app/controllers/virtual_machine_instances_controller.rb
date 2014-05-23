class VirtualMachineInstancesController < ApplicationController
  before_action :set_virtual_machine_instance, only: [:destroy]
  before_action :search_virtual_machine_instance, only: [:complete_benchmark, :complete_postprocessing]

  def index
    @virtual_machine_instances = VirtualMachineInstance.paginate(page: params[:page])
  end

  def complete_benchmark
    if @virtual_machine_instance.present?
      continue = params[:continue].present? ? boolean_value(params[:continue]) : true
      @virtual_machine_instance.complete_benchmark(continue, boolean_value(params[:success]))
      head 200 # ok
    else
      head 422 # unprocessable_entity
    end
  end

  def complete_postprocessing
    if @virtual_machine_instance.present?
      @virtual_machine_instance.complete_postprocessing(boolean_value(params[:success]))
      head 200 # ok
    else
      head 422 # unprocessable_entity
    end
  end

  def destroy
    @virtual_machine_instance.destroy
    redirect_to virtual_machine_instances_url
  end

  private
    def set_virtual_machine_instance
      @virtual_machine_instance = VirtualMachineInstance.find(params[:id])
    end

    def search_virtual_machine_instance
      @virtual_machine_instance = VirtualMachineInstance.where(provider_name: params[:provider_name], provider_instance_id: params[:provider_instance_id]).first
    end

    def virtual_machine_instance_params
      params.require(:virtual_machine_instance).permit(:benchmark_execution_id, :status, :provider_name, :provider_instance_id)
    end

    def boolean_value(param)
      params[:continue].to_s == 'true'
    end
end
