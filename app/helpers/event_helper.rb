# frozen_string_literal: true

module EventHelper
  def has_log(event)
    event.started_preparing? || event.started_releasing_resources?
  end

  def previous_event_on_same_day(event)
    prev = event.previous
    prev.present? && same_day(event.happened_at, prev.happened_at)
  end

  def previous_event_on_other_day(event)
    !previous_event_on_same_day(event)
  end
end
