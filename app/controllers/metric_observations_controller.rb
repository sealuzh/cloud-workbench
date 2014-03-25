class MetricObservationsController < ApplicationController
  before_action :set_metric_observation, only: [:show, :edit, :update, :destroy]

  # GET /metric_observations
  # GET /metric_observations.json
  def index
    @metric_observations = MetricObservation.all
  end

  # GET /metric_observations/1
  # GET /metric_observations/1.json
  def show
  end

  # GET /metric_observations/new
  def new
    @metric_observation = MetricObservation.new
  end

  # GET /metric_observations/1/edit
  def edit
  end

  # POST /metric_observations
  # POST /metric_observations.json
  def create
    @metric_observation = MetricObservation.new(metric_observation_params)

    respond_to do |format|
      if @metric_observation.save
        format.html { redirect_to @metric_observation, notice: 'Metric observation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @metric_observation }
      else
        format.html { render action: 'new' }
        format.json { render json: @metric_observation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /metric_observations/1
  # PATCH/PUT /metric_observations/1.json
  def update
    respond_to do |format|
      if @metric_observation.update(metric_observation_params)
        format.html { redirect_to @metric_observation, notice: 'Metric observation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @metric_observation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /metric_observations/1
  # DELETE /metric_observations/1.json
  def destroy
    @metric_observation.destroy
    respond_to do |format|
      format.html { redirect_to metric_observations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metric_observation
      @metric_observation = MetricObservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def metric_observation_params
      params.require(:metric_observation).permit(:key, :value)
    end
end
