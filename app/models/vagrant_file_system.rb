require 'erb'
require 'fileutils'
class VagrantFileSystem
  attr_reader :benchmark_definition, :benchmark_execution

  def initialize(benchmark_definition, benchmark_execution)
    @benchmark_definition = benchmark_definition
    @benchmark_execution = benchmark_execution
  end

  def prepare_vagrantfile_for_driver
    create_directory_structure
    vagrantfile = evaluate_vagrantfile
    create_vagrantfile(vagrantfile)
  end

  def create_directory_structure
    FileUtils.mkdir_p(benchmark_execution_dir)
    FileUtils.mkdir_p(vagrant_dir)
    FileUtils.mkdir_p(log_dir)
  end

  def evaluate_vagrantfile
    template = ERB.new VagrantConfig.instance.base_file
    vagrantfile_binding = VagrantfileBinding.new(benchmark: @benchmark_definition,
                                                 execution: @benchmark_execution,
                                                 benchmark_name_sanitized: benchmark_name_sanitized)
    template.result(vagrantfile_binding.get_binding)
  end

  def create_vagrantfile(vagrantfile)
    File.open(vagrantfile_path, 'w') do |file|
      file.write(vagrantfile)
    end
  end

  def remove_vagrant_dir
    FileUtils.remove_dir(benchmark_execution_dir)
  end

  def benchmark_definition_dir
    File.join(base_path, benchmark_definition_dir_name)
  end

  def base_path
    Rails.application.config.benchmark_executions
  end

  def benchmark_definition_dir_name
    aligned_id = @benchmark_definition.id.to_s.rjust(3, '0')
    "#{aligned_id}-#{benchmark_name_sanitized}"
  end

  def benchmark_name_sanitized
    sanitize_dir_name(@benchmark_definition.name)
  end

  # Replace all non-word-characters [^\w] with an underscore '_'
  # Word characters are [A-Za-z0-9_]
  def sanitize_dir_name(name)
    name.gsub(/\W/, '_')
  end

  def benchmark_execution_dir
    File.join(benchmark_definition_dir, benchmark_execution_dir_name)
  end

  def benchmark_execution_dir_name
    # Example: '13' becomes '0013'
    aligned_id = @benchmark_execution.id.to_s.rjust(4, '0')
    "#{aligned_id}"
  end

  def vagrant_dir
    File.join(benchmark_execution_dir, 'vagrant')
  end

  def vagrantfile_path
    File.join(vagrant_dir, 'Vagrantfile')
  end

  def log_dir
    File.join(benchmark_execution_dir, 'log')
  end
end