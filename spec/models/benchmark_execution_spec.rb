require 'spec_helper'

describe BenchmarkExecution do
  before do
    @benchmark_execution = create(:benchmark_execution)
  end

  subject { @benchmark_execution }

  it { should respond_to(:benchmark_definition) }
  it { should respond_to(:virtual_machine_instances) }

  it { should be_valid }

  describe "when benchmark definition is not present" do
    before { @benchmark_execution.benchmark_definition_id = 77 }
    it { should_not be_valid }
  end

  describe "prepare" do
    before { @benchmark_execution.prepare }
    its(:status) { should eq 'WAITING FOR RUN' }
  end
end