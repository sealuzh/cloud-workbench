require 'spec_helper'

describe "Metric observation creation" do
  let(:vm) { create(:virtual_machine_instance) }
  let(:benchmark) { vm.benchmark_execution.benchmark_definition }

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

    it "should create a new nominal metric observation" do
      expect(NominalMetricObservation.where(time: time, value: value).count).to eq 1
    end
  end

  def post_create(metric, vm, time, value)
    post '/metric_observations', :metric_observation => {
        metric_definition_id: metric.id,
        provider_name: vm.provider_name,
        provider_instance_id: vm.provider_instance_id,
        time: time,
        value: value
    }
  end
end