# frozen_string_literal: true

module BenchmarkSchedulesHelper
  def toggle_benchmark_schedule_link(schedule)
    toggle_benchmark_schedule(schedule, activate_class: 'activate-color', deactivate_class: 'deactivate-color')
  end

  def toggle_benchmark_schedule_btn(schedule)
    toggle_benchmark_schedule(schedule, activate_class: 'btn btn-default', deactivate_class: 'btn btn-default')
  end

  def toggle_benchmark_schedule(schedule, opts = {})
    if schedule.active?
      link_to "#{pause_icon}&nbsp;Deactivate Schedule".html_safe, deactivate_benchmark_schedule_path(schedule), method: :patch, class: opts[:deactivate_class]
    else
      link_to "#{start_icon}&nbsp;Activate Schedule".html_safe, activate_benchmark_schedule_path(schedule), method: :patch, class: opts[:activate_class]
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

  def total_active_schedules_badge(opts = {})
    actives_count = BenchmarkSchedule.actives.count
    unless opts[:conditional].present? && opts[:conditional].to_s == 'true' && actives_count <= 0
      link_to actives_count, benchmark_schedules_path(active: true), class: "badge bg-green badge-total #{opts[:html_class]}"
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
