class BenchmarkDefinition < ActiveRecord::Base
  has_many :metric_definitions, dependent: :destroy
  has_many :benchmark_executions, dependent: :destroy do
    def has_active?
      actives.any?
    end
    def actives
      actives = []
      self.each { |execution| actives.append(execution) if execution.active? }
      actives
    end
  end
  # Notice: Uniqueness constraint may be violated by occurring race conditions with database adapters
  # that do not support case-sensitive indices. This case should practically never occur is therefore not handled.
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { in: 3..50 }
  # TODO: Add further validations and sanity checks for Vagrantfile after dry-up has been completed.
  validates :vagrantfile, presence: true
  has_one :benchmark_schedule

  def self.start_execution_async_for_id(benchmark_definition_id)
    benchmark_definition = find(benchmark_definition_id)
    benchmark_definition.start_execution_async
  end

  # May throw an exception on save or enqueue
  def start_execution_async
    benchmark_execution = benchmark_executions.build
    benchmark_execution.status = "WAITING FOR PREPARATION"
    benchmark_execution.save!
    enqueue_prepare_job(benchmark_execution)
    benchmark_execution
  end

  # May throw an exception on enqueue
  def enqueue_prepare_job(benchmark_execution)
    begin
      prepare_job = PrepareBenchmarkExecutionJob.new(benchmark_execution.id)
      Delayed::Job.enqueue(prepare_job)
    rescue => e
      benchmark_execution.destroy
      raise e
    end
  end
end
