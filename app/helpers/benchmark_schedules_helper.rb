module BenchmarkSchedulesHelper
  def toggle_benchmark_schedule_link(schedule)
    if schedule.active?
      link_to "#{pause_icon}&nbsp;Deactivate".html_safe, deactivate_benchmark_schedule_path(schedule), method: :patch, class: 'deactivate-color'
    else
      link_to "#{start_icon}&nbsp;Activate".html_safe, activate_benchmark_schedule_path(schedule), method: :patch, class: 'activate-color'
    end
  end

  def toggle_benchmark_schedule_btn(schedule)
    if schedule.active?
      link_to "#{pause_icon}&nbsp;Deactivate Schedule".html_safe, deactivate_benchmark_schedule_path(schedule), method: :patch, class: 'btn btn-default'
    else
      link_to "#{start_icon}&nbsp;Activate Schedule".html_safe, activate_benchmark_schedule_path(schedule), method: :patch, class: 'btn btn-default'
    end
  end

  # You may pass optional html parameters such as { class: 'pull-right', title: 'I'm a tooltip }
  def benchmark_schedule_label(schedule, opts={})
    if schedule.active?
      schedule_label(schedule, 'success', opts)
    else
      schedule_label(schedule, 'default', opts)
    end
  end

  private

    def schedule_label(schedule, type, opts)
      base_html_class = "label label-#{type}"
      html_class = opts[:class].present? ? "#{base_html_class} #{opts[:class]}" : base_html_class
      args = opts.merge({ class: html_class })
      link_to schedule.cron_expression, edit_benchmark_schedule_path(schedule), args
    end
end
