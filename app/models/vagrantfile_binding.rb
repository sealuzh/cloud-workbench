# frozen_string_literal: true

class VagrantfileBinding
  attr_reader :execution
  attr_reader :benchmark_name_sanitized

  def initialize(opts)
    @benchmark = opts[:benchmark]
    @execution = opts[:execution]
    @benchmark_name_sanitized = opts[:benchmark_name_sanitized]
  end

  def benchmark_id
    @benchmark.id
  end

  def benchmark_name
    @benchmark.name
  end

  def vagrantfile
    @benchmark.vagrantfile
  end

  def execution_id
    @execution.id
  end

  def provider_name
    @benchmark.provider_name
  end

  # Expose methods of this class
  def get_binding
    binding
  end
end
