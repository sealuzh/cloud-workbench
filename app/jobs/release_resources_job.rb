class ReleaseResourcesJob < Struct.new(:benchmark_definition_id, :benchmark_execution_id)
  def perform
    benchmark_definition = BenchmarkDefinition.find(benchmark_definition_id)
    benchmark_execution = BenchmarkExecution.find(benchmark_execution_id)

    benchmark_execution.status = 'RELEASING_RESOURCES'
    benchmark_execution.save

    logging_path = "#{benchmark_definition.vagrant_directory_path}/.vagrant/log"
    FileUtils.mkdir_p(logging_path)
    log_file = "#{logging_path}/vagrant_destroy.log"

    %x( cd "#{benchmark_definition.vagrant_directory_path}" &&
        vagrant destroy --force >>#{log_file} 2>&1 )

    if $?.success?
      benchmark_execution.status = 'FINISHED'
      benchmark_execution.end_time = Time.now
      benchmark_execution.save
    else
      puts "Vagrant destroy failed. See logfile: #{log_file}"
      benchmark_execution.status = 'FAILED_ON_RELEASING_RESOURCES'
      benchmark_execution.save
    end

  end
end