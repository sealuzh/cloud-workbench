class MetricObservation
  include ActiveModel::Model

  def initialize(attributes = {})
    # attributes.each do |name, value|
    #   send("#{name}=", value)
    # end

    virtual_machine_instance = VirtualMachineInstance.where(provider_name: attributes[:provider_name], provider_instance_id: attributes[:provider_instance_id]).first
    @ordered_metric_observation = OrderedMetricObservation.new(metric_definition_id: attributes[:metric_definition_id], virtual_machine_instance_id: virtual_machine_instance.id,
                                                               time: attributes[:time], value: attributes[:value])
  end

  def persisted?
    true
  end

  # NOTE: new is routed to initialize
  def new

    # metric_definition = MetricDefinition.find(params[:metric_observation][:metric_definition_id])
    # # TODO: Handle different metric observations, single insert (inline), and bulk insert (via file e.g. CSV)
    # if metric_definition.scale_type == "NOMINAL"
    #   # metric_definition.nominal_metric_observations.create()
    # else
    #   # metric_definition.ordered_metric_observations.create()
    # end




    # Consider passing a MetricObservation ActiveModel instance to the concrete metrics.
    # ordered_metric_observation = OrderedMetricObservation.new(metric_definition_id: params[:metric_observation][:metric_definition_id],
    #                                                           time: params[:metric_observation][:time],
    #                                                           value: params[:metric_observation][:value])

    # redirect_to ordered_metric_observation_path(ordered_metric_observation), notice: 'Ordered metric observation was successfully created.'
  end

  def save(options = {})
    @ordered_metric_observation.save(validate: false) # Don't validate since VM instance id is missing yet
  end

  def save!(options = {})
    fail NotImplementedError
  end
end