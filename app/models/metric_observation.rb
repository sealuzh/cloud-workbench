class MetricObservation
  include ActiveModel::Model

  attr_accessor(:metric_definition_id, :provider_name, :provider_instance_id, :time, :value)

  def initialize(attributes = {})
    super
    unless attributes.empty?
      virtual_machine_instance = VirtualMachineInstance.where(provider_name: attributes[:provider_name], provider_instance_id: attributes[:provider_instance_id]).first
      metric_definition = MetricDefinition.find(attributes[:metric_definition_id])
      if metric_definition.scale_type.nominal?
        @metric_observation = NominalMetricObservation.new(metric_definition_id: attributes[:metric_definition_id], virtual_machine_instance_id: virtual_machine_instance.id,
                                                                   time: attributes[:time], value: attributes[:value])
      else
        @metric_observation = OrderedMetricObservation.new(metric_definition_id: attributes[:metric_definition_id], virtual_machine_instance_id: virtual_machine_instance.id,
                                                                 time: attributes[:time], value: attributes[:value])
      end
    end
  end

  # Persistence is implemented via concrete MetricObservations models e.g. NominalMetricObservation, OrderedMetricObservation
  # MUST return false in order to correctly display the form as otherwise an ActiveRecord id is required
  def persisted?
    false
  end

  def save
    @metric_observation.save
  end

  def save!
    @metric_observation.save!
  end
end