# Abstraction for different types of MetricObservations:
# * The implementation detail which MetricObservation (e.g. nominal, ordered) should remain hidden for a client.
# * The concrete implementation is chosen based on the metric_type from the associated MetricDefinition
class MetricObservationsController < ApplicationController
  def new
    @metric_observation = MetricObservation.new
  end

  # This action is NOT idempotent as a RESTful resource should be. It would be too costly to search the entire metrics for identical entries
  def create
    @metric_observation = MetricObservation.new(metric_observations_params)
    if @metric_observation.save
      respond_to do |format|
        format.json { render json: @metric_observation, status: :created }
        format.html do
          flash[:success] = "Metric observation (#{@metric_observation.concrete_metric_observation.class.name}) was successfully created."
          method_name = "#{@metric_observation.concrete_metric_observation.class.name.underscore}_path"
          # Redirect to CONCRETE_metric_observation (either nominal or ordered)
          redirect_to send(method_name.to_sym, @metric_observation.concrete_metric_observation)
        end
      end
    else
      respond_to do |format|
        format.json { head :internal_server_error }
        format.html { render action: 'new' }
      end
    end
  end

  # Bulk import of metric observations
  def import
    # TODO: Handle bulk import via CSV
    render status: :not_implemented
  end

  private

    def metric_observations_params
      params.require(:metric_observation).permit(:metric_definition_id, :provider_name, :provider_instance_id, :time, :value)
    end
end