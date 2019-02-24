# frozen_string_literal: true

module StatusHelper
  LINE_BREAK_STRINGS = [
      'WAITING FOR',
      'FAILED ON',
  ]
  def split_status(status)
    line_break_string = LINE_BREAK_STRINGS.find { |line_break_string| status.start_with?(line_break_string) }
    line_break_string.present? ? [line_break_string, second_part(status, line_break_string)] : nil
  end

  def line_breaked_status(status)
    parts = split_status(status)
    parts.present? ? "#{parts[0]}<br>#{parts[1]}".html_safe : status
  end

  def status_first_part(status)
    split_status(status)[0] rescue status
  end

  def status_second_part(status)
    split_status(status)[1] rescue ''
  end

  def status_label(status, type = 'default')
    "<span class='label label-#{type}'>#{line_breaked_status(status)}</span>".html_safe
  end

  def status_link(status, type, path)
    link_to line_breaked_status(status), path, class: "label label-#{type}"
  end

  def active_status(active)
    active ? "#{active_icon}&nbsp;Still active".html_safe : "#{finished_icon}&nbsp;Finished".html_safe
  end

  def status_bg_color(failed)
    failed ? 'bg-red' : 'bg-green'
  end

  def status_icon(failed, html_class = '')
    failed ? ion_icon("close #{html_class}") : ion_icon("checkmark #{html_class}")
  end

  private

    def second_part(status, line_break_string)
      status.split(line_break_string)[1]
    end
end
