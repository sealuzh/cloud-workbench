module StatusHelper
  LINE_BREAK_STRINGS = [
      'WAITING FOR',
      'FAILED ON',
  ]
  def line_breaked_status(status)
    line_break_string = LINE_BREAK_STRINGS.find { |line_break_string| status.start_with?(line_break_string) }
    if line_break_string
      "#{line_break_string}<br>#{second_part(status, line_break_string)}".html_safe
    else
      status
    end
  end

  def status_label(status, type = 'default')
    "<span class='label label-#{type}'>#{line_breaked_status(status)}</span>".html_safe
  end

  def active_status(active)
    active ? "#{active_icon}&nbsp;Still active".html_safe : "#{finished_icon}&nbsp;Finished".html_safe
  end

  def status_bg_color(failed)
    failed ? 'red' : 'green'
  end

  def status_icon(failed)
    failed ? ion_icon('close') : ion_icon('checkmark')
  end

  private

  def second_part(status, line_break_string)
    status.split(line_break_string)[1]
  end
end