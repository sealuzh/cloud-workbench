require 'spec_helper'

describe BenchmarkExecution do
  let(:benchmark_execution) { create(:benchmark_execution) }

  subject { benchmark_execution }

  it { should respond_to(:benchmark_definition) }
  it { should respond_to(:virtual_machine_instances) }

  it { should be_valid }

  describe "when benchmark definition is not present" do
    before { benchmark_execution.benchmark_definition_id = 77 }
    it { should_not be_valid }
  end

  describe "successful prepare" do
    let(:driver) { double('driver', up: true) }
    before do
      benchmark_execution.prepare_with(driver)
    end
    its(:status) { should eq 'WAITING FOR RUN' }
    end

  describe "failed prepare" do
    let(:driver) { double('driver', up: false) }
    before do
      benchmark_execution.prepare_with(driver) rescue nil
    end
    its(:status) { should eq('FAILED ON PREPARING') }
  end

  describe "successful start" do
    let(:benchmark_runner) { double('benchmark runner', start_benchmark: true) }
    before do
      benchmark_execution.start_benchmark_with(benchmark_runner)
    end
    its(:status) { should eq('RUNNING') }
    end

  describe "failed start" do
    let(:benchmark_runner) { double('benchmark runner', start_benchmark: false) }
    before do
      benchmark_execution.start_benchmark_with(benchmark_runner) rescue nil
    end
    its(:status) { should eq('FAILED ON START BENCHMARK') }
  end

  describe "successful start postprocessing" do
    let(:benchmark_runner) { double('benchmark runner', start_postprocessing: true) }
    before do
      benchmark_execution.start_postprocessing_with(benchmark_runner)
    end
    its(:status) { should eq('POSTPROCESSING') }
    end

  describe "failed start postprocessing" do
    let(:benchmark_runner) { double('benchmark runner', start_postprocessing: false) }
    before do
      benchmark_execution.start_postprocessing_with(benchmark_runner) rescue nil
    end
    its(:status) { should eq('FAILED ON START POSTPROCESSING') }
  end

  describe "successful release resources" do
    let(:driver) { double('driver', destroy: true) }
    before do
      benchmark_execution.release_resources_with(driver)
    end
    its(:status) { should eq('FINISHED') }
  end

  describe "failed release resources" do
    let(:driver) { double('driver', destroy: false) }
    before do
      benchmark_execution.release_resources_with(driver) rescue nil
    end
    its(:status) { should eq('FAILED ON RELEASING RESOURCES') }
  end

  describe "detection and creation of vm instances" do
    let(:vm_instance) { build(:virtual_machine_instance) }
    let(:driver) { build(:vagrant_driver) }
    before do
      benchmark_execution.detect_and_create_vm_instances_with(driver)
    end

    it "should detect a single aws vm instance" do
      expect do
        benchmark_execution.detect_and_create_vm_instances_with(driver)
      end.to change(VirtualMachineInstance, :count).by(1)
    end

    subject { VirtualMachineInstance.find_by_provider_instance_id(vm_instance.provider_instance_id) }
    its(:provider_name) { should eq(vm_instance.provider_name) }
    its(:provider_instance_id) { should eq(vm_instance.provider_instance_id) }
    its(:role) { should eq(vm_instance.role) }

  end
end