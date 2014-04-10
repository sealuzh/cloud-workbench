class NominalMetricObservationsController < ApplicationController
  before_action :set_metric_observation, only: [:show, :edit, :update, :destroy]

  # GET /nominal_metric_observations
  def index
    @nominal_metric_observations = NominalMetricObservation.all
  end

  # GET /nominal_metric_observations/1
  def show
  end

  # GET /nominal_metric_observations/new
  def new
    @nominal_metric_observation = NominalMetricObservation.new
  end

  # GET /nominal_metric_observations/1/edit
  def edit
  end

  # POST /nominal_metric_observations
  def create
    @nominal_metric_observation = NominalMetricObservation.new(metric_observation_params)

    if @nominal_metric_observation.save
      redirect_to @nominal_metric_observation, notice: 'Ordered metric observation was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /metric_observations/1
  def update
    if @nominal_metric_observation.update(metric_observation_params)
      redirect_to @nominal_metric_observation, notice: 'Metric observation was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /metric_observations/1
  def destroy
    @nominal_metric_observation.destroy
    redirect_to nominal_metric_observations_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metric_observation
      @nominal_metric_observation = NominalMetricObservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def metric_observation_params
      params.require(:nominal_metric_observation).permit(:metric_definition_id, :virtual_machine_instance_id, :time, :value)
    end
end
