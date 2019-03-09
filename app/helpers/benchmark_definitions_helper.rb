# frozen_string_literal: true

module BenchmarkDefinitionsHelper
  def confirm_delete_benchmark_msg(benchmark_definition)
    { confirm: (render 'benchmark_definitions/confirm_delete', benchmark_definition: benchmark_definition) }
  end

  def schedule_metric_sidebar(benchmark_definition, benchmark_execution = {})
    observation_link_params = benchmark_execution.present? ? { benchmark_execution_id: benchmark_execution.id } : {}
    render 'shared/schedule_metric_sidebar', benchmark_definition: @benchmark_definition,
                                             benchmark_schedule:   @benchmark_definition.benchmark_schedule,
                                             metric_definitions:   @benchmark_definition.metric_definitions.sort_by(&:name),
                                             observation_link_params: observation_link_params
  end

  def vagrantfile_error?(benchmark_definition)
    benchmark_definition.errors[:vagrantfile].any?
  end

  def start_execution_link(benchmark_definition, opts)
    link_to "#{start_icon}&nbsp;Start Execution".html_safe, [benchmark_definition, benchmark_definition.benchmark_executions.build],
                method: :post, class: opts[:class],
                data: confirm_start_execution_msg(benchmark_definition)
  end
end
