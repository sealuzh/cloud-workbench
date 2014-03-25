class VirtualMachineInstancesController < ApplicationController
  before_action :set_virtual_machine_instance, only: [:show, :edit, :update, :destroy]

  # GET /virtual_machine_instances
  # GET /virtual_machine_instances.json
  def index
    @virtual_machine_instances = VirtualMachineInstance.all
  end

  # GET /virtual_machine_instances/1
  # GET /virtual_machine_instances/1.json
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
  # POST /virtual_machine_instances.json
  def create
    @virtual_machine_instance = VirtualMachineInstance.new(virtual_machine_instance_params)

    respond_to do |format|
      if @virtual_machine_instance.save
        format.html { redirect_to @virtual_machine_instance, notice: 'Virtual machine instance was successfully created.' }
        format.json { render action: 'show', status: :created, location: @virtual_machine_instance }
      else
        format.html { render action: 'new' }
        format.json { render json: @virtual_machine_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /virtual_machine_instances/1
  # PATCH/PUT /virtual_machine_instances/1.json
  def update
    respond_to do |format|
      if @virtual_machine_instance.update(virtual_machine_instance_params)
        format.html { redirect_to @virtual_machine_instance, notice: 'Virtual machine instance was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @virtual_machine_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /virtual_machine_instances/1
  # DELETE /virtual_machine_instances/1.json
  def destroy
    @virtual_machine_instance.destroy
    respond_to do |format|
      format.html { redirect_to virtual_machine_instances_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_virtual_machine_instance
      @virtual_machine_instance = VirtualMachineInstance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def virtual_machine_instance_params
      params.require(:virtual_machine_instance).permit(:status)
    end
end
