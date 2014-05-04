require 'erb'
require 'ostruct'

FactoryGirl.define do
  factory :benchmark_definition do
    sequence(:name) { |n| "fio-benchmark #{n}" }
    sequence(:vagrantfile) do |n|
        namespace = OpenStruct.new(n: n)
        file_dir = File.expand_path File.dirname(__FILE__)
        vagrantfile_template = "#{file_dir}/factories/Vagrantfile.erb"
        template = ERB.new File.read(vagrantfile_template)
        template.result(namespace.instance_eval { binding })
    end
  end

  factory :benchmark_execution do
    association :benchmark_definition, factory: :benchmark_definition
    status 'WAITING FOR PREPARATION'
  end

  factory :vagrant_file_system do
    association :benchmark_execution, factory: :benchmark_execution
    benchmark_definition { benchmark_execution.benchmark_definition }

    initialize_with { new(benchmark_definition, benchmark_execution) }
  end
end