module BenchmarkDefinitionsHelper
  def vagrantfile_template
    template = ERB.new File.read(Rails.application.config.vagrantfile_template)
    template.result
  end

  def confirm_delete_benchmark_msg(benchmark_definition)
    { confirm: (render 'benchmark_definitions/confirm_delete', benchmark_definition: benchmark_definition) }
  end

  def schedule_metric_sidebar(benchmark_definition, benchmark_execution = {})
    observation_link_params = benchmark_execution.present? ? { benchmark_execution_id: benchmark_execution.id } : {}
    render 'shared/schedule_metric_sidebar', benchmark_definition: @benchmark_definition,
                                             benchmark_schedule:   @benchmark_definition.benchmark_schedule,
                                             metric_definitions:   @benchmark_definition.metric_definitions,
                                             observation_link_params: observation_link_params
  end
end
