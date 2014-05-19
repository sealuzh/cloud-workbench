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

  def live_log_id(event)
    if event.started_preparing?
      'prepare'
    elsif event.started_releasing_resources?
      'releaseResources'
    end
  end

  def live_log_path(event)
    if event.started_preparing?
      prepare_log_benchmark_execution_path(event.traceable, format: :txt)
    elsif event.started_releasing_resources?
      release_resources_log_benchmark_execution_path(event.traceable, format: :txt)
    end
  end
end
