module BenchmarkSchedulesHelper
  def toggle_benchmark_schedule_btn(schedule)
    if schedule.active?
      link_to "#{pause_icon}&nbsp;Deactivate".html_safe, deactivate_benchmark_schedule_path(schedule), method: :patch, class: 'deactivate-color'
    else
      link_to "#{start_icon}&nbsp;Activate".html_safe, activate_benchmark_schedule_path(schedule), method: :patch, class: 'activate-color'
    end
  end
end
