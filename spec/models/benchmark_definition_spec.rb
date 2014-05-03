require 'spec_helper'

describe BenchmarkDefinition do

  before do
    @benchmark_definition = create(:benchmark_definition)
  end

  subject { @benchmark_definition }

  it { should respond_to(:name) }
  it { should respond_to(:vagrantfile) }
  it { should respond_to(:metric_definitions) }
  it { should respond_to(:benchmark_executions) }
  it { should respond_to(:benchmark_schedule) }

  it { should be_valid }

  describe "when name is not present" do
    before { @benchmark_definition.name = ' ' }
    it { should_not be_valid }
  end

  describe "when same name (case insensitive) already exists" do
    before do
      @same_name_definition = build(:benchmark_definition, name: @benchmark_definition.name.upcase)
    end
    specify { expect(@same_name_definition).not_to be_valid }
  end

  describe "when Vagrantfile is invalid" do
    before { @benchmark_definition.vagrantfile = ' ' }
    it { should_not be_valid }
    pending("Add further Vagrantfile validations and sanity checks")
  end

  describe "start new execution" do
    before { @execution = @benchmark_definition.start_execution_async }
    it "should create a new benchmark execution" do
      @execution.benchmark_definition .should eq(@benchmark_definition)
      @execution.status .should eq('WAITING FOR PREPARATION')
    end

    it "should create an asynchronous job" do
      expect do
        @benchmark_definition.start_execution_async
      end.to change(Delayed::Job, :count).by(1)
    end

  end

end