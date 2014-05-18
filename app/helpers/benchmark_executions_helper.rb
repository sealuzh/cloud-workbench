module BenchmarkExecutionsHelper
  def execution_status_label(execution)
    if execution.failed?
      type = 'danger'
    elsif execution.active?
      type = 'default'
    elsif execution.finished?
      type = 'success'
    elsif execution.inactive?
      type = 'warning'
    end
    status_label(execution.status, type)
  end

  def confirm_start_execution_msg(execution)
    { confirm: "This will start a benchmark execution of the <strong>#{execution.name}</strong> benchmark" }
  end

  def confirm_delete_execution_msg(execution)
    { confirm: (render 'benchmark_executions/confirm_delete', benchmark_execution: execution) }
  end
end
