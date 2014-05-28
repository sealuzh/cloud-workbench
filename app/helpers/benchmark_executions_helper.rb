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

  def execution_active_indicator(execution)
    fa_icon "cog #{'spin' if execution.active?}"
  end

  def toggle_keep_alive_execution_btn(execution)
    if execution.keep_alive?
      link_to "#{fa_icon("moon-o")}&nbsp;Disable keep alive".html_safe, toggle_keep_alive_benchmark_execution_path(execution, keep_alive: false),
              method: :patch, class: 'btn btn-info btn-block', data: confirm_disable_keep_alive_execution_msg
    else
      link_to "#{fa_icon("sun-o")}&nbsp;Enable keep alive".html_safe, toggle_keep_alive_benchmark_execution_path(execution, keep_alive: true),
              method: :patch, class: 'btn btn-default btn-block', data: confirm_enable_keep_alive_execution_msg
    end
  end

  def confirm_start_execution_msg(execution)
    { confirm: "This will start a benchmark execution of the <strong>#{execution.name}</strong> benchmark." }
  end

  def confirm_reprovision_msg
    { confirm: "This action will reprovision the virtual machines again and continue with starting the benchmark." }
  end

  def confirm_enable_keep_alive_execution_msg
    { confirm: "This action will prevent the virtual machines of this execution from being released.<br>
                <strong>IMPORTANT: Make sure you release the resources of this execution e.g. by using the abort action.
                Anyway you MUST disable the keep alive flag before you can successfully use the abort action.</strong>" }
  end

  def confirm_disable_keep_alive_execution_msg
    { confirm: "This action will activate any scheduled release resources jobs again.<br>
                <strong>IMPORTANT: Make sure you release the resources of this execution yourself (e.g. by using the abort action)
                in case there are no more release resources jobs scheduled.</strong>" }
  end

  def confirm_restart_benchmark_msg(execution)
    { confirm: "This action will try to restart the benchmark again via SSH. It starts the start_runner script again." }
  end

  def confirm_abort_execution_msg(execution)
    { confirm: "This action will abort the execution by terminating all running virtual machine instances." }
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
      duration = execution.benchmark_duration
      duration == 0 ? '' : distance_of_time_in_words(duration).humanize
    else
      if execution.failed?
        'Not started'
      else
        'Not started yet'
      end
    end
  end

  def execution_duration_formatted(execution)
    if execution.started?
      duration = execution.duration
      duration == 0 ? '' : distance_of_time_in_words(duration).humanize
    else
      if execution.failed?
        'Not started'
      else
        'Not started yet'
      end
    end
  end

  # No usages yet: NOTE: This is a very expensive operation as the active state is calculated based on the event model
  # def total_active_executions_badge(opts = {})
  #   actives_count = BenchmarkExecution.actives.count
  #   unless opts[:conditional].present? && opts[:conditional].to_s == 'true' && actives_count <= 0
  #     link_to actives_count, benchmark_executions_path(active: true), class: "badge bg-green badge-total #{opts[:html_class]}"
  #   end
  # end
end
