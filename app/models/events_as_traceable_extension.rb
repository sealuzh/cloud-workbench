module EventsAsTraceableExtension
  def create_with_name!(name)
    create!(name: name, happened_at: Time.current)
  end

  def first_with_name(name)
    self.find { |event| event.name.to_s == name.to_s }
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