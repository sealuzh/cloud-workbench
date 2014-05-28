class NominalMetricObservationsController < ApplicationController
  before_action :set_metric_observation, only: [:destroy]

  def destroy
    @nominal_metric_observation.destroy
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metric_observation
      @nominal_metric_observation = NominalMetricObservation.find(params[:id])
    end
end
