require 'spec_helper'

describe BenchmarkExecution do
  let(:benchmark_definition) { create(:benchmark_definition) }
  let(:benchmark_execution) { benchmark_definition.start_execution_async }

  subject { benchmark_execution }

  it { should respond_to(:events) }
  it { should respond_to(:benchmark_definition) }
  it { should respond_to(:virtual_machine_instances) }

  it { should be_valid }
  its(:events) { should contain_event :created }
  its(:failed?) { should be_false }
  it "should have no failed events" do
    expect(benchmark_execution.events.first_failed).to be_nil
  end
  its(:active?) { should be_true }

  describe "when benchmark definition is not present" do
    let(:non_existent_id) { 77 }
    before { benchmark_execution.benchmark_definition_id = non_existent_id }
    it { should_not be_valid }
  end

  describe "successful prepare" do
    let(:driver) { double('driver', up: true) }
    before do
      benchmark_execution.prepare_with(driver)
    end
    its(:events) { should contain_event :started_preparing }
    its(:status) { should eq 'WAITING FOR START RUNNING' }
    end

  describe "failed prepare" do
    let(:driver) { double('driver', up: false) }
    before do
      benchmark_execution.prepare_with(driver) rescue nil
    end
    its(:events) { should contain_event :failed_on_preparing }
    its(:status) { should eq('FAILED ON PREPARING') }
    its(:failed?) { should be_true }
    it "should have a failed event with the correct name" do
      expect(benchmark_execution.events.first_failed.name).to eq(:failed_on_preparing.to_s)
    end
  end

  describe "successful start running" do
    let(:benchmark_runner) { double('benchmark runner', start_benchmark: true) }
    before do
      benchmark_execution.start_benchmark_with(benchmark_runner)
    end
    its(:events) { should contain_event :started_running }
    its(:events) { should_not contain_event :finished_running }
    its(:status) { should eq('RUNNING') }
    end

  describe "failed start running" do
    let(:benchmark_runner) { double('benchmark runner', start_benchmark: false) }
    before do
      benchmark_execution.start_benchmark_with(benchmark_runner) rescue nil
    end
    its(:events) { should contain_event :failed_on_start_running }
    its(:status) { should eq('FAILED ON START RUNNING') }
  end

  describe "successful start postprocessing" do
    let(:benchmark_runner) { double('benchmark runner', start_postprocessing: true) }
    before do
      benchmark_execution.start_postprocessing_with(benchmark_runner)
    end
    its(:events) { should contain_event :started_postprocessing }
    its(:status) { should eq('POSTPROCESSING') }
    end

  describe "failed start postprocessing" do
    let(:benchmark_runner) { double('benchmark runner', start_postprocessing: false) }
    before do
      benchmark_execution.start_postprocessing_with(benchmark_runner) rescue nil
    end
    its(:events) { should contain_event :failed_on_start_postprocessing }
    its(:status) { should eq('FAILED ON START POSTPROCESSING') }
  end

  describe "successful release resources" do
    let(:driver) { double('driver', destroy: true) }
    before do
      benchmark_execution.release_resources_with(driver)
    end
    its(:events) { should contain_event :started_releasing_resources }
    its(:events) { should contain_event :finished_releasing_resources }
    its(:status) { should eq('FINISHED') }
    its(:active?) { should be_false }
  end

  describe "failed release resources" do
    let(:driver) { double('driver', destroy: false) }
    before do
      benchmark_execution.release_resources_with(driver) rescue nil
    end
    its(:events) { should contain_event :started_releasing_resources }
    its(:events) { should contain_event :failed_on_releasing_resources }
    its(:status) { should eq('FAILED ON RELEASING RESOURCES') }
    its(:active?) { should be_false }
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