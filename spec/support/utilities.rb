RSpec::Matchers.define :contain_event do |expected|
  match do |events|
    events.select { |event| event.name.to_s == expected.to_s }.any?
  end
  failure_message_for_should do |events|
    "expected that #{events} would contain an event with the name #{expected}"
  end
  failure_message_for_should_not do |events|
    "expected that #{events} would not contain an event with the name #{expected}"
  end
end