class MetricDefinitionsController < ApplicationController
  before_action :set_metric_definition, only: [:show, :edit, :update, :destroy]

  # GET /metric_definitions
  def index
    @metric_definitions = MetricDefinition.all
  end

  # GET /metric_definitions/1
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
  def create
    @metric_definition = MetricDefinition.new(metric_definition_params)

    if @metric_definition.save
      redirect_to @metric_definition, notice: 'Metric definition was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /metric_definitions/1
  def update
    if @metric_definition.update(metric_definition_params)
      redirect_to @metric_definition, notice: 'Metric definition was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /metric_definitions/1
  def destroy
    @metric_definition.destroy
    redirect_to metric_definitions_url
  end

  private
    def set_metric_definition
      @metric_definition = MetricDefinition.find(params[:id])
    end

    def metric_definition_params
      params.require(:metric_definition).permit(:benchmark_definition_id, :name, :unit, :scale_type)
    end
end
