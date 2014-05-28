module EventsAsTraceableExtension
  def create_with_name!(name, message = '')
    create!(name: name, happened_at: Time.current, message: message)
  end

  def first_with_name(name)
    self.find { |event| same_name(event.name, name) }
  end

  def last_with_name(name)
    self.select { |event| event if same_name(event.name, name) }.last rescue nil
  end

  def same_name(first, second)
    first.to_s == second.to_s
  end

  def first_failed
    self.find { |event| event.failed? }
  end

  def any_failed?
    first_failed.present?
  end

  def status_from_history
    if any_failed?
      first_failed.status
    elsif self.any?
      self.last.status
    else
      'UNDEFINED'
    end
  end
end