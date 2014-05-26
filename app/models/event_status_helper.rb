module EventStatusHelper
  # Traceable (e.g. Execution)
  def active?
    # Executions without id may just be built from a view (e.g. start execution button) and does not really exist
    id.present? && !has_event_with_name?(:finished_releasing_resources) && !has_event_with_name?(:failed_on_releasing_resources)
  end

  def inactive?
    !active?
  end

  def failed?
    events.any_failed?
  end

  def status
    events.status_from_history
  end

  def duration
    if active?
      Time.current - start_time
    elsif end_time.present?
      end_time - start_time
    else
      0
    end
  end

  def started?
    has_event_with_name?(:created)
  end

  def start_time
    time_of_first_event_with_name(:created)
  end

  def finished?
    has_event_with_name?(:finished_releasing_resources)
  end

  def end_time
    time_of_first_event_with_name(:finished_releasing_resources) || time_of_first_event_with_name(:failed_on_releasing_resources)
  end

  # Benchmark
  def benchmark_active?
    benchmark_started? && !benchmark_finished?
  end

  def benchmark_duration
    if benchmark_active?
      Time.current - benchmark_start_time
    elsif benchmark_finished?
      benchmark_end_time - benchmark_start_time
    else
      0
    end
  end

  def benchmark_started?
    has_event_with_name?(:started_running)
  end

  def benchmark_start_time
    time_of_first_event_with_name(:started_running)
  end

  def benchmark_finished?
    has_event_with_name?(:finished_running) ||
        has_event_with_name?(:finished_postprocessing) ||
        has_event_with_name?(:started_releasing_resources) ||
        has_event_with_name?(:finished_releasing_resources)
  end

  # Attempt to guess the end time even if the benchmark does not notify benchmark completed
  def benchmark_end_time
    time_of_first_event_with_name(:finished_running) ||
        time_of_first_event_with_name(:finished_postprocessing) ||
        time_of_first_event_with_name(:started_releasing_resources) ||
        time_of_first_event_with_name(:finished_releasing_resources)
  end

  # Event Helpers
  def has_event_with_name?(name)
    events.first_with_name(name).present?
  end

  def time_of_first_event_with_name(name)
    first = events.first_with_name(name)
    first.present? ? first.happened_at : nil
  end
end