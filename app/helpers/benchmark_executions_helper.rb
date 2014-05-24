module BenchmarkExecutionsHelper
  def execution_status_label(execution)
    if execution.failed?
      type = 'danger'
    elsif execution.active?
      type = 'success'
    elsif execution.finished?
      type = 'default'
    elsif execution.inactive?
      type = 'warning'
    end
    status_link(execution.status, type, execution)
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

  def benchmark_duration_formatted(execution)
    if execution.benchmark_started?
      distance_of_time_in_words(execution.benchmark_duration).humanize
    else
      'Not started yet.'
    end
  end

  def total_active_executions_badge(opts = {})
    actives_count = BenchmarkExecution.actives.count
    unless opts[:conditional].present? && opts[:conditional].to_s == 'true' && actives_count <= 0
      link_to actives_count, benchmark_executions_path(active: true), class: "badge bg-green badge-total #{opts[:html_class]}"
    end
  end
end
