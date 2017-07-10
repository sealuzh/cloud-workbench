require 'erb'
require 'ostruct'

FactoryGirl.define do
  factory :benchmark_definition do
    provider_name 'aws'
    sequence(:name) { |n| "fio-benchmark #{n}" }
    running_timeout 10
    sequence(:vagrantfile) do |n|
        namespace = OpenStruct.new(n: n)
        file_dir = File.expand_path File.dirname(__FILE__)
        vagrantfile_example = "#{file_dir}/factories/Vagrantfile.erb"
        template = ERB.new File.read(vagrantfile_example)
        template.result(namespace.instance_eval { binding })
    end
  end

  factory :benchmark_schedule do
    association :benchmark_definition, factory: :benchmark_definition
    cron_expression '30 * * * *'
    active true
  end

  factory :benchmark_execution do
    association :benchmark_definition, factory: :benchmark_definition
  end

  # Currently not needed
  # factory :event do
  #   name :created
  #   association :traceable, factory: :benchmark_execution
  #   happened_at Time.zone.parse('14-05-2014 8:00:00')
  # end

  factory :virtual_machine_instance do
    association :benchmark_execution, factory: :benchmark_execution
    role 'default'
    provider_name 'aws'
    provider_instance_id 'i-3ba0b07b'
  end

  factory :vagrant_file_system do
    association :benchmark_execution, factory: :benchmark_execution
    benchmark_definition { benchmark_execution.benchmark_definition }

    skip_create
    initialize_with { new(benchmark_definition, benchmark_execution) }
  end

  factory :vagrant_driver do
    vagrantfile_path "#{Rails.application.config.spec_files}/vagrant_driver/single_aws_instance/Vagrantfile"
    log_dir nil

    skip_create
    initialize_with { new(vagrantfile_path, log_dir) }
  end

  factory :metric_definition do
    association :benchmark_definition, factory: :benchmark_definition
    name 'default metric'
    scale_type 'ratio'

    factory :ratio_metric_definition do
      name 'seq. write'
      unit 'mb/s'
      scale_type 'ratio'
    end

    factory :nominal_metric_definition do
      name 'cpu type'
      scale_type 'nominal'
    end
  end

  factory :user do
    email Rails.application.config.default_email
    password Rails.application.config.default_password
  end
end