RSpec::Matchers.define :contain_event do |expected|
  match do |events|
    events.select { |event| event.name.to_s == expected.to_s }.any?
  end
  failure_message_for_should do |events|
    "expected that #{event_names(events)} would contain an event with the name #{expected}"
  end
  failure_message_for_should_not do |events|
    "expected that #{event_names(events)} would not contain an event with the name #{expected}"
  end

  # Provide descriptive error message: [created, started_preparing]
  def event_names(events)
    '[' + events.map { |event| event.name}.join(', ') + ']'
  end
end