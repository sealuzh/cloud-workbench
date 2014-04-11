class MetricObservation
  include ActiveModel::Model

  attr_accessor(:metric_definition_id, :provider_name, :provider_instance_id, :time, :value)
  attr_reader(:concrete_metric_observation)

  # Persistence is implemented via concrete MetricObservations models e.g. NominalMetricObservation, OrderedMetricObservation
  # MUST return false in order to correctly display the form as otherwise an ActiveRecord id is required
  def persisted?
    false
  end

  def save
    complete_attributes
    @concrete_metric_observation.save
  end

  def save!
    complete_attributes
    @concrete_metric_observation.save!
  end

  private

    def complete_attributes
      virtual_machine_instance = VirtualMachineInstance.where(provider_name: @provider_name, provider_instance_id: @provider_instance_id).first
      metric_definition = MetricDefinition.find(@metric_definition_id)
      if metric_definition.scale_type.nominal?
        @concrete_metric_observation = NominalMetricObservation.new(metric_definition_id: @metric_definition_id, virtual_machine_instance_id: virtual_machine_instance.id,
                                                           time: @time, value: @value)
      else
        @concrete_metric_observation = OrderedMetricObservation.new(metric_definition_id: @metric_definition_id, virtual_machine_instance_id: virtual_machine_instance.id,
                                                           time: @time, value: @value)
      end
    end
end