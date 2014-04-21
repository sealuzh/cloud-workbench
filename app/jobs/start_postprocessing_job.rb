class StartPostprocessingJob < Struct.new(:benchmark_definition_id)
  def perform
    benchmark_definition = BenchmarkDefinition.find(benchmark_definition_id)
    # TODO: Handle exit code, Avoid sudo, Handle situation when runner don't do a nohup => kill job
    %x( cd "#{benchmark_definition.vagrant_directory_path}" &&
        vagrant ssh -- "sudo bash -c '/usr/local/cloud-benchmark/stop_and_postprocess_runner.sh'" )
  end
end