class StartPostprocessingJob < Struct.new(:benchmark_definition_id)
  def perform
    benchmark_definition = BenchmarkDefinition.find(benchmark_definition_id)
    %x( cd "#{benchmark_definition.vagrant_directory_path}" &&
        vagrant ssh -- "sudo bash -c 'cd /usr/local/cloud-benchmark && pwd; nohup ./start_postprocessing > postprocessing.stdout.log 2> postprocessing.stderr.log < /dev/null &'" )
  end
end