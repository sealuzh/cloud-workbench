# frozen_string_literal: true

class NominalMetricObservationsController < ApplicationController
  before_action :set_metric_observation, only: [:destroy]

  def destroy
    @nominal_metric_observation.destroy
    redirect_back(fallback_location: root_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metric_observation
      @nominal_metric_observation = NominalMetricObservation.find(params[:id])
    end
end
