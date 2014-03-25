class MetricDefinitionsController < ApplicationController
  before_action :set_metric_definition, only: [:show, :edit, :update, :destroy]

  # GET /metric_definitions
  # GET /metric_definitions.json
  def index
    @metric_definitions = MetricDefinition.all
  end

  # GET /metric_definitions/1
  # GET /metric_definitions/1.json
  def show
  end

  # GET /metric_definitions/new
  def new
    @metric_definition = MetricDefinition.new
  end

  # GET /metric_definitions/1/edit
  def edit
  end

  # POST /metric_definitions
  # POST /metric_definitions.json
  def create
    @metric_definition = MetricDefinition.new(metric_definition_params)

    respond_to do |format|
      if @metric_definition.save
        format.html { redirect_to @metric_definition, notice: 'Metric definition was successfully created.' }
        format.json { render action: 'show', status: :created, location: @metric_definition }
      else
        format.html { render action: 'new' }
        format.json { render json: @metric_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /metric_definitions/1
  # PATCH/PUT /metric_definitions/1.json
  def update
    respond_to do |format|
      if @metric_definition.update(metric_definition_params)
        format.html { redirect_to @metric_definition, notice: 'Metric definition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @metric_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /metric_definitions/1
  # DELETE /metric_definitions/1.json
  def destroy
    @metric_definition.destroy
    respond_to do |format|
      format.html { redirect_to metric_definitions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metric_definition
      @metric_definition = MetricDefinition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def metric_definition_params
      params.require(:metric_definition).permit(:name, :unit)
    end
end
