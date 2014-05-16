module ApplicationHelper
  def formatted_time(time)
    time.present? ? time.to_formatted_s(:db) : '-'
  end

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

  private

    def second_part(status, line_break_string)
      status.split(line_break_string)[1]
    end
end
