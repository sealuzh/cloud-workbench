class VirtualMachineInstance < ActiveRecord::Base
  belongs_to :benchmark_execution
  validates :benchmark_execution, presence: true
  has_many :nominal_metric_observations, dependent: :destroy
  has_many :ordered_metric_observations, dependent: :destroy

  def complete_benchmark(continue, success = true)
    if success
      create_event!(:finished_running)
      if continue
        create_event!(:started_postprocessing)
      else
        Delayed::Job.enqueue(StartPostprocessingJob.new(benchmark_execution_id))
      end
    else
      create_event!(:failed_on_running)
      Delayed::Job.enqueue(ReleaseResourcesJob.new(benchmark_execution_id))
    end
  end

  def complete_postprocessing(success = true)
    if success
      create_event!(:finished_postprocessing)
    else
      create_event!(:failed_on_postprocessing)
    end
    Delayed::Job.enqueue(ReleaseResourcesJob.new(benchmark_execution_id))
  end

  private

    def create_event!(type)
      benchmark_execution.events.create_with_name!(type)
    end
end
