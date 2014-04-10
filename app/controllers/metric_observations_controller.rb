class MetricObservationsController < ApplicationController
  def new
    @metric_observation = MetricObservation.new
  end

  # Abstraction for different types of MetricObservations:
  # * The implementation detail which MetricObservation (e.g. nominal, ordered) should remain hidden for a client.
  # * The concrete implementation is chosen based on the metric_type from the associated MetricDefinition
  def create
    # TODO: impl.
    # virtual_machine_instance = VirtualMachineInstance.find_by(provider: params[:provider], )
    # metric_definition = MetricDefinition.find_by_metric(params[:metric_definition_id])
    # if metric_definition.scale_type == "NOMINAL"
    #   NominalMetricObservation.build(time: params[:time], value: params[:value])
    # end

    # @metric_observation = MetricObservation.new(:metric_observation => { key: params[:metric_observation][:time], value: params[:metric_observation][:value] })

    # if @metric_observation.save
    #   redirect_to @metric_observation, notice: 'Metric observation was successfully created.'
    # else
    #   render action: 'new'
    # end

    # Consider passing a MetricObservation ActiveModel instance to the concrete metrics.
    ordered_metric_observation = OrderedMetricObservation.new(metric_definition_id: params[:metric_observation][:metric_definition_id],
                                                               time: params[:metric_observation][:time],
                                                               value: params[:metric_observation][:value])
    ordered_metric_observation.save!(:validate => false) # Don't validate since VM instance id is missing yet

    redirect_to ordered_metric_observation_path(ordered_metric_observation), notice: 'Ordered metric observation was successfully created.'
  end
end