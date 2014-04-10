class OrderedMetricObservationsController < ApplicationController
  before_action :set_ordered_metric_observation, only: [:show, :edit, :update, :destroy]

  # GET /ordered_metric_observations
  def index
    @ordered_metric_observations = OrderedMetricObservation.all
  end

  # GET /ordered_metric_observations/1
  def show
  end

  # GET /ordered_metric_observations/new
  def new
    @ordered_metric_observation = OrderedMetricObservation.new
  end

  # GET /ordered_metric_observations/1/edit
  def edit
  end

  # POST /ordered_metric_observations
  def create
    @ordered_metric_observation = OrderedMetricObservation.new(ordered_metric_observation_params)

    if @ordered_metric_observation.save
      redirect_to @ordered_metric_observation, notice: 'Ordered metric observation was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /ordered_metric_observations/1
  def update
    if @ordered_metric_observation.update(ordered_metric_observation_params)
      redirect_to @ordered_metric_observation, notice: 'Ordered metric observation was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /ordered_metric_observations/1
  def destroy
    @ordered_metric_observation.destroy
      redirect_to ordered_metric_observations_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ordered_metric_observation
      @ordered_metric_observation = OrderedMetricObservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ordered_metric_observation_params
      params.require(:ordered_metric_observation).permit(:metric_definition_id, :virtual_machine_instance_id, :time, :value)
    end
end
