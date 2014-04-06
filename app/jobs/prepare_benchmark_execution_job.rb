class PrepareBenchmarkExecutionJob < Struct.new(:benchmark_definition_id)
  def perform
    puts "Preparing benchmark with id #{benchmark_definition_id}"
    benchmark_definition = BenchmarkDefinition.find(benchmark_definition_id)
    %x( cd "#{benchmark_definition.vagrant_directory_path}";
        pwd >> #{Rails.root.join('public', 'pwd_test.txt')} )
  end
end