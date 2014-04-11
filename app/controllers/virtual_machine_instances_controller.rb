class VirtualMachineInstancesController < ApplicationController
  before_action :set_virtual_machine_instance, only: [:show, :edit, :update, :destroy]

  # GET /virtual_machine_instances
  def index
    @virtual_machine_instances = VirtualMachineInstance.all
  end

  # GET /virtual_machine_instances/1
  def show
  end

  # GET /virtual_machine_instances/new
  def new
    @virtual_machine_instance = VirtualMachineInstance.new
  end

  # GET /virtual_machine_instances/1/edit
  def edit
  end

  # POST /virtual_machine_instances
  def create
    @virtual_machine_instance = VirtualMachineInstance.new(virtual_machine_instance_params)

    if @virtual_machine_instance.save
      redirect_to @virtual_machine_instance, notice: 'Virtual machine instance was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /virtual_machine_instances/1
  def update
    if @virtual_machine_instance.update(virtual_machine_instance_params)
      redirect_to @virtual_machine_instance, notice: 'Virtual machine instance was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /virtual_machine_instances/1
  def destroy
    @virtual_machine_instance.destroy
    redirect_to virtual_machine_instances_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_virtual_machine_instance
      @virtual_machine_instance = VirtualMachineInstance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def virtual_machine_instance_params
      params.require(:virtual_machine_instance).permit(:benchmark_execution_id, :status, :provider_name, :provider_instance_id)
    end
end
