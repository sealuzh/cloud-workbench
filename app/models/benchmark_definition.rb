require 'fileutils'

class BenchmarkDefinition < ActiveRecord::Base
  before_destroy :remove_vagrant_directory
  has_many :metric_definitions
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
  # that do not support case-sensitive indices.
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  # validates :vagrantfile, presence: true # TODO: enable when switched from file to db backed Vagrantfile

  VAGRANT_PATH = "#{Rails.root}/public/benchmark_definitions"
  VAGRANT_FILE_NAME = 'Vagrantfile'

# TODO: Consider using RESTful design for the vagrant file: Vagrantfile as RESTful resource. Refactor into module?
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
