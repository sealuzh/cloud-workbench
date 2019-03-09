# frozen_string_literal: true

class OrderedMetricObservationsController < ApplicationController
  before_action :set_ordered_metric_observation, only: [:destroy]

  def destroy
    @ordered_metric_observation.destroy
    redirect_back(fallback_location: root_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ordered_metric_observation
      @ordered_metric_observation = OrderedMetricObservation.find(params[:id])
    end
end
