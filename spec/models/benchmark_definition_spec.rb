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

  context "without existing executions" do
    describe "any_valid?" do
      it "should have no valid executions" do
        expect(@benchmark_definition.benchmark_executions.any_valid?).to be_false
      end
    end

    describe "any_valid? after building an execution" do
      before { @benchmark_definition.benchmark_executions.build }
      it "should have no valid executions" do
        expect(@benchmark_definition.benchmark_executions.any_valid?).to be_false
      end
    end

    describe "start new execution" do
      before { @execution = @benchmark_definition.start_execution_async }

      it "should create a new benchmark execution" do
        @execution .should_not be_nil
      end

      it "should include the execution as active" do
        expect(@benchmark_definition.benchmark_executions.actives).to include(@execution)
      end

      it "should have any valid executions" do
        expect(@benchmark_definition.benchmark_executions.any_valid?).to be_true
      end

      describe "benchmark execution" do
        subject { @execution }
        its(:benchmark_definition) { should eq @benchmark_definition }
        its(:status) { should eq 'WAITING FOR START PREPARING' }
      end

      it "should create an asynchronous job" do
        expect do
          @benchmark_definition.start_execution_async
        end.to change(Delayed::Job, :count).by(1)
      end
    end

    describe "listing active executions" do
      let(:active_execution) { @benchmark_definition.start_execution_async }
      let(:inactive_execution) { @benchmark_definition.start_execution_async }

      before { inactive_execution.events.create_with_name!(:finished_releasing_resources) }

      it "should include the active execution" do
        expect(active_execution.active?).to be_true
        expect(@benchmark_definition.benchmark_executions.actives).to include(active_execution)
      end

      it "should not include the inactive execution" do
        expect(inactive_execution.active?).to be_false
        expect(@benchmark_definition.benchmark_executions.actives).not_to include(inactive_execution)
      end
    end
  end

  context "with existing executions" do
    describe "editing a benchmark definition" do
      before do
        @benchmark_definition.benchmark_executions.create
        @benchmark_definition.name = "NEW and #{@benchmark_definition.name}"
      end

      it "should not allow to edit the name" do
        expect(@benchmark_definition.save).to be_false
      end
    end
  end
end