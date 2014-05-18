module BenchmarkExecutionsHelper
  def execution_status_label(benchmark_execution)
    if benchmark_execution.failed?
      type = 'danger'
    elsif benchmark_execution.active?
      type = 'default'
    elsif benchmark_execution.finished?
      type = 'success'
    elsif benchmark_execution.inactive?
      type = 'warning'
    end
    status_label(benchmark_execution.status, type)
  end

  def confirm_start_execution_msg(benchmark_definition)
    { confirm: "This will start a benchmark execution of the <strong>#{benchmark_definition.name}</strong> benchmark" }
  end
end
