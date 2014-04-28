require 'forwardable'
class MetricObservation
  attr_accessor(:provider_name, :provider_instance_id)
  attr_reader(:concrete_metric_observation)

  include ActiveModel::Model
  extend Forwardable

  # Delegate the common methods to the concrete implementation.
  def_delegators :@concrete_metric_observation, :time,
                                                :value,
                                                :virtual_machine_instance,
                                                :virtual_machine_instance_id,
                                                :metric_definition,
                                                :metric_definition_id

  # Persistence is implemented via concrete MetricObservations models e.g. NominalMetricObservation, OrderedMetricObservation
  # MUST return false in order to correctly display the form as otherwise an ActiveRecord id is required
  def persisted?
    false
  end

  def initialize(args = {})
    # Delete used arguments to prevent mass assignment error later
    @provider_name = args.delete :provider_name
    @provider_instance_id = args.delete :provider_instance_id
    # Use NominalMetricObservation as default implementation if none is provided as
    # the string value is more generic than the float of OrderedMetricObservation
    @concrete_metric_observation = args[:default_implementation] || NominalMetricObservation.new(args)
  end

  def save
    complete_attributes
    @concrete_metric_observation.save
  end

  def save!
    complete_attributes
    @concrete_metric_observation.save!
  end

  # You MUST provide a metric_definition_id as argument
  def self.where(opts = {})
    metric_definition = MetricDefinition.find(opts[:metric_definition_id])
    if metric_definition.scale_type.nominal?
      NominalMetricObservation.where(opts)
    else
      OrderedMetricObservation.where(opts)
    end
  end

  # You MUST provide a metric_definition_id as argument
  def self.search(params)
    observations = scope_builder
    benchmark_definition_id = BenchmarkDefinition.find_by_name(params[:benchmark_definition_name],
                                                               case_sensitive: false).id
    observations.where("benchmark_definition_id == ?", benchmark_definition_id)
    # TODO: Continue impl.
  end

  private

    def complete_attributes
      virtual_machine_instance = VirtualMachineInstance.where(provider_name: @provider_name,
                                                              provider_instance_id: @provider_instance_id).first
      metric_definition = MetricDefinition.find(metric_definition_id)
      if metric_definition.scale_type.nominal?
        @concrete_metric_observation = NominalMetricObservation.new(metric_definition_id: metric_definition_id,
                                                                    virtual_machine_instance_id: virtual_machine_instance.id,
                                                                    time: time, value: value)
      else
        @concrete_metric_observation = OrderedMetricObservation.new(metric_definition_id: metric_definition_id,
                                                                    virtual_machine_instance_id: virtual_machine_instance.id,
                                                                    time: time, value: value)
      end
    end

    def self.scope_builder
      DynamicDelegator.new(scoped)
    end
end