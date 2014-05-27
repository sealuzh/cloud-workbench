require 'spec_helper'

describe MetricDefinitionsController do
  let(:vm) { create(:virtual_machine_instance) }
  let(:benchmark) { vm.benchmark_execution.benchmark_definition }

  describe "single observation creation" do

    describe "of ratio scale metric" do
      let(:ratio_metric) { create(:ratio_metric_definition, benchmark_definition: benchmark) }
      let(:time) { '500' }
      let(:value) { '1024' }

      before do
        post_create(ratio_metric, vm, time, value)
      end

      it "should return the status code 201 for created" do
        expect(response.status).to eq(201) # created
      end

      it "should create a new ratio metric observation" do
        expect(OrderedMetricObservation.where(time: time, value: value).count).to eq 1
      end
    end

    describe "of nominal scale metric" do
      let(:nominal_metric) { create(:nominal_metric_definition, benchmark_definition: benchmark) }
      let(:time) { '0' }
      let(:value) { 'Xeon CPU x2' }

      before do
        post_create(nominal_metric, vm, time, value)
      end

      it "should return the status code 201 for created" do
        expect(response.status).to eq(201) # created
      end

      it "should create a new nominal metric observation with the correct values" do
        expect(NominalMetricObservation.where(time: time, value: value).count).to eq 1
      end
    end

    def post_create(metric, vm, time, value)
      post '/metric_observations', :metric_observation => {
          metric_definition_id: metric.name, # metric.id should also be valid
          provider_name: vm.provider_name,
          provider_instance_id: vm.provider_instance_id,
          time: time,
          value: value
      }
    end
  end

  describe "bulk import" do
    let(:ratio_metric) { create(:ratio_metric_definition, benchmark_definition: benchmark) }

    describe "of ratio scale metrics" do

      describe "with small samples" do
        before do
          post_import(ratio_metric, vm, "#{Rails.application.config.spec_files}/metric_observations/results_small.csv")
        end

        it "should return the status code 201 for created" do
          expect(response.status).to eq(201) # created
        end

        it "should create new ratio metric observations from the csv data" do
          ratio_metric_observations = OrderedMetricObservation.where(metric_definition_id: ratio_metric.id)
          expect(ratio_metric_observations.count).to eq 20 # number of samples in csv

          # Test boundary samples
          check_observation(ratio_metric_observations,   501, 1373) # First entry
          check_observation(ratio_metric_observations,  8548, 1464) # 17st entry
          check_observation(ratio_metric_observations, 10053, 1540) # Last entry
        end
      end

      describe "with large samples", :slow do
        before do
          post_import(ratio_metric, vm, "#{Rails.application.config.spec_files}/metric_observations/results_big.csv")
        end

        it "should return the status code 201 for created" do
          expect(response.status).to eq(201) # created
        end

        it "should create new ratio metric observations from the csv data" do
          ratio_metric_observations = OrderedMetricObservation.where(metric_definition_id: ratio_metric.id)
          expect(ratio_metric_observations.count).to eq 1978 # number of samples in csv

          # Test boundary samples
          check_observation(ratio_metric_observations,    501, 1373) # First entry
          check_observation(ratio_metric_observations, 505247,  982) # 1000st entry
          check_observation(ratio_metric_observations, 997515, 1141) # Last entry
        end
      end
    end
  end

  def post_import(metric, vm, file, file_type = 'text/csv')
    post import_metric_observations_path,
     {  metric_observation: {
          metric_definition_id: metric.id,
          provider_name: vm.provider_name,
          provider_instance_id: vm.provider_instance_id,
          file: Rack::Test::UploadedFile.new(file, file_type)
        }
     }
  end

  def check_observation(observations, time, value)
    expect(observations.where(time: time, value: value).count). to eq 1
  end
end