module TimeHelper
  def formatted_time(time, format = :db)
    time.present? ? time.to_formatted_s(format) : '-'
  end
end