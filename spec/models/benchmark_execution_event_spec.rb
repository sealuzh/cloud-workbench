require 'spec_helper'

describe "Events of benchmark execution" do
  let(:execution) { create(:benchmark_execution) }

  describe "benchmark duration" do
    subject { execution.benchmark_duration }

    context "after started running" do
      before { execution.events.create_with_name!(:started_running, '') }

      it { should be > 0 }

      it "should continuously increase" do
        duration1 = execution.benchmark_duration
        duration2 = execution.benchmark_duration
        expect(duration2).to be > duration1
      end

      context "of inactive execution" do
        before do
          execution.events.create_with_name!(:finished_releasing_resources)
        end

        it "should stay the same" do
          duration1 = execution.benchmark_duration
          duration2 = execution.benchmark_duration
          expect(duration1).to be duration2
        end
      end
    end
  end

  describe "execution duration" do

  end
end