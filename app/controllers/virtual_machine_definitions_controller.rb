class VirtualMachineDefinitionsController < ApplicationController
  before_action :set_virtual_machine_definition, only: [:show, :edit, :update, :destroy]

  # GET /virtual_machine_definitions
  # GET /virtual_machine_definitions.json
  def index
    @virtual_machine_definitions = VirtualMachineDefinition.all
  end

  # GET /virtual_machine_definitions/1
  # GET /virtual_machine_definitions/1.json
  def show
  end

  # GET /virtual_machine_definitions/new
  def new
    @virtual_machine_definition = VirtualMachineDefinition.new
  end

  # GET /virtual_machine_definitions/1/edit
  def edit
  end

  # POST /virtual_machine_definitions
  # POST /virtual_machine_definitions.json
  def create
    @virtual_machine_definition = VirtualMachineDefinition.new(virtual_machine_definition_params)

    respond_to do |format|
      if @virtual_machine_definition.save
        format.html { redirect_to @virtual_machine_definition, notice: 'Virtual machine definition was successfully created.' }
        format.json { render action: 'show', status: :created, location: @virtual_machine_definition }
      else
        format.html { render action: 'new' }
        format.json { render json: @virtual_machine_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /virtual_machine_definitions/1
  # PATCH/PUT /virtual_machine_definitions/1.json
  def update
    respond_to do |format|
      if @virtual_machine_definition.update(virtual_machine_definition_params)
        format.html { redirect_to @virtual_machine_definition, notice: 'Virtual machine definition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @virtual_machine_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /virtual_machine_definitions/1
  # DELETE /virtual_machine_definitions/1.json
  def destroy
    @virtual_machine_definition.destroy
    respond_to do |format|
      format.html { redirect_to virtual_machine_definitions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_virtual_machine_definition
      @virtual_machine_definition = VirtualMachineDefinition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def virtual_machine_definition_params
      params.require(:virtual_machine_definition).permit(:role, :region, :instance_type, :image)
    end
end
