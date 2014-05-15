class BenchmarkDefinition < ActiveRecord::Base
  has_many :metric_definitions, dependent: :destroy
  has_many :benchmark_executions, dependent: :destroy do
    def has_active?
      actives.any?
    end

    def actives
      self.select { |execution| execution.active? }
    end

    # any? does consider built executions via self.benchmark_execution.build
    # Therefore the any valid check is required to determine whether there are existing executions.
    # Otherwise unexpected results appear on views with a start execution button.
    def any_valid?
      first_valid = self.find { |execution| execution.id.present? }
      first_valid.present?
    end
  end

  # Notice: Uniqueness constraint may be violated by occurring race conditions with database adapters
  # that do not support case-sensitive indices. This case should practically never occur is therefore not handled.
  MAX_NAME_LENGTH = 70
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { in: 3..MAX_NAME_LENGTH }
  # TODO: Add further validations and sanity checks for Vagrantfile after dry-up has been completed.
  validates :vagrantfile, presence: true
  has_one :benchmark_schedule, dependent: :destroy
  before_save :ensure_name_integrity


  def self.max_name_length
    MAX_NAME_LENGTH
  end

  def self.start_execution_async_for_id(benchmark_definition_id)
    benchmark_definition = find(benchmark_definition_id)
    benchmark_definition.start_execution_async
  end

  # May throw an exception on create or enqueue
  def start_execution_async
    benchmark_execution = benchmark_executions.create!
    benchmark_execution.events.create_with_name!(:created)
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

  private

    def ensure_name_integrity
      if self.name_changed? && self.benchmark_executions.any?
        errors.add(:base, 'The name of a benchmark definition cannot be changed if any benchmark executions are present.')
        false
      else
        true
      end
    end
end
