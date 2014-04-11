# Abstraction for different types of MetricObservations:
# * The implementation detail which MetricObservation (e.g. nominal, ordered) should remain hidden for a client.
# * The concrete implementation is chosen based on the metric_type from the associated MetricDefinition
class MetricObservationsController < ApplicationController
  def new
    @metric_observation = MetricObservation.new
  end

  # REVIEW: Idempotence of this create (and the import) method should be guaranteed for RESTful design. Use something like: CONCRETE_metric_observation = find_by_id(row["id"]) || new
  def create
    @metric_observation = MetricObservation.new(metric_observations_params)
    if @metric_observation.save
      flash[:success] = 'Metric observation was successfully created.'

      # TODO: Redirect to CONCRETE_metric_observation (either nominal or ordered)
      # redirect_to @metric_observation, notice: 'Metric observation was successfully created.'
      redirect_to ordered_metric_observations_path
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