# frozen_string_literal: true

class VirtualMachineInstance < ApplicationRecord
  belongs_to :benchmark_execution
  validates :benchmark_execution, presence: true
  has_many :nominal_metric_observations, dependent: :destroy
  has_many :ordered_metric_observations, dependent: :destroy
  default_scope { order('created_at DESC') }

  def complete_benchmark(continue, success = true, message = '')
    if success
      create_event!(:finished_running)
      if continue
        create_event!(:started_postprocessing)
      else
        Delayed::Job.enqueue(StartPostprocessingJob.new(benchmark_execution_id))
      end
    else
      create_event!(:failed_on_running, message)
      benchmark_execution.shutdown_after_failure_timeout
    end
  end

  def complete_postprocessing(success = true, message = '')
    if success
      create_event!(:finished_postprocessing)
    else
      create_event!(:failed_on_postprocessing, message)
    end
    Delayed::Job.enqueue(ReleaseResourcesJob.new(benchmark_execution_id))
  end

  private

    def create_event!(name, message = '')
      benchmark_execution.events.create_with_name!(name, message)
    end
end
