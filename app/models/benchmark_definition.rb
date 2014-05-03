require 'fileutils'
class BenchmarkDefinition < ActiveRecord::Base
  before_destroy :remove_vagrant_directory
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
    benchmark_execution.status = "WAITING FOR ASYNC START"
    benchmark_execution.save!
    begin
      Delayed::Job.enqueue(PrepareBenchmarkExecutionJob.new(self.id, benchmark_execution.id))
    rescue => e
      benchmark_execution.destroy
      raise e
    end
    benchmark_execution
  end


  VAGRANT_PATH = "#{Rails.root}/public/benchmark_definitions"
  VAGRANT_FILE_NAME = 'Vagrantfile'

# TODO: Consider using RESTful design for the vagrant file: Vagrantfile as RESTful resource. Refactor into VagrantDriver class.
# See: http://stackoverflow.com/questions/15889750/editing-file-in-rails-using-text-area
  def save_vagrant_file(vagrant_file_content)
    FileUtils.mkdir_p(vagrant_directory_path)
    vagrant_file = File.new(vagrant_file_path, File::CREAT|File::TRUNC|File::WRONLY)
    vagrant_file.write(vagrant_file_content)
    vagrant_file.close
  end

  def vagrant_file_path
    File.join(VAGRANT_PATH, self.id.to_s, VAGRANT_FILE_NAME)
  end

  def vagrant_directory_path
    File.dirname(vagrant_file_path)
  end

  def vagrant_file_content
    File.read(vagrant_file_path)
  end


  private

    def remove_vagrant_directory
      FileUtils.remove_dir(vagrant_directory_path)
    end
end
