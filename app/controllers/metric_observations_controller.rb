# Abstraction for different types of MetricObservations:
# * The implementation detail which MetricObservation (e.g. nominal, ordered) should remain hidden for a client.
# * The concrete implementation is chosen based on the metric_type from the associated MetricDefinition
class MetricObservationsController < ApplicationController
  def new
    @metric_observation = MetricObservation.new
  end

  # This action is NOT idempotent as a RESTful resource should be. It would be too costly to search the entire metrics for same entries
  # NOTE: Consider renaming to submit to indicate that this action isn't idempotent
  def create
    @metric_observation = MetricObservation.new(metric_observations_params)
    if @metric_observation.save
      flash[:success] = 'Metric observation was successfully created.'

      # Redirect to CONCRETE_metric_observation (either nominal or ordered)
      method_name = "#{@metric_observation.concrete_metric_observation.class.name.underscore}_path"
      # => This should be a 'machine' interface only
      # redirect_to send(method_name.to_sym, @metric_observation.concrete_metric_observation)
      render status: 200, json: @metric_observation.to_json
    else
      render action: 'new'
    end
  end

  # Bulk import of metric observations
  def import
    # TODO: Handle bulk import via CSV
  end

  private

    def metric_observations_params
      params.require(:metric_observation).permit(:metric_definition_id, :provider_name, :provider_instance_id, :time, :value)
    end
end