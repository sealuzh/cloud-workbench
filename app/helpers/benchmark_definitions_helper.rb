module BenchmarkDefinitionsHelper
  def vagrantfile_template
    template = ERB.new File.read(Rails.application.config.vagrantfile_template)
    template.result
  end

  def confirm_delete_benchmark_msg(benchmark_definition)
    { confirm: (render 'benchmark_definitions/confirm_delete', benchmark_definition: benchmark_definition) }
  end
end
