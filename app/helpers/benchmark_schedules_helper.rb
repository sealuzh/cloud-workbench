module BenchmarkSchedulesHelper
  def toggle_benchmark_schedule_btn(schedule)
    if schedule.active?
      link_to "#{pause_icon}&nbsp;Deactivate".html_safe, deactivate_benchmark_schedule_path(schedule), method: :patch, class: 'deactivate-color'
    else
      link_to "#{start_icon}&nbsp;Activate".html_safe, activate_benchmark_schedule_path(schedule), method: :patch, class: 'activate-color'
    end
  end

  def benchmark_schedule_label(schedule)
    if schedule.active?
      schedule_label(schedule, 'success')
    else
      schedule_label(schedule, 'default')
    end
  end

  private

    def schedule_label(schedule, type)
      link_to schedule.cron_expression, schedule, class: "label label-#{type} schedule-align", title: schedule.cron_expression_in_english.html_safe
    end
end
