require 'spec_helper'

# include DurationModule
include TimeDiff::Matchers
describe "Events of benchmark execution" do
  let(:execution) { create(:benchmark_execution) }
  subject { execution }

  describe "execution_duration" do
    its(:execution_duration) { should be > 0 }
    specify { expect{execution.execution_duration}.to increase_over_time }
  end

  context "after started preparing," do
    before { create_event(:started_preparing) }


    context "finished preparing," do
      before { create_event(:finished_preparing) }
      describe "benchmark duration" do
        its(:benchmark_duration) { should eq 0 }
        specify { expect{execution.benchmark_duration}.to remain_over_time }
      end

      context "started running," do
        before { create_event(:started_running) }
        describe "benchmark duration" do
          its(:benchmark_duration) { should be > 0 }
          specify { expect{execution.benchmark_duration}.to increase_over_time }
        end

        context "finished running," do
          before { create_event(:finished_running) }
          describe "benchmark duration" do
            specify { expect{execution.benchmark_duration}.to remain_over_time }
          end

          context "started_postprocessing," do
            before { create_event(:started_postprocessing) }

            context "finished_postprocessing," do
              before { create_event(:finished_postprocessing) }

              context "started_releasing_resources," do
                before { create_event(:started_releasing_resources) }

                context "finished_releasing_resources" do
                  before { create_event(:finished_releasing_resources) }

                  describe "execution duration" do
                    specify { expect{execution.execution_duration}.to remain_over_time }
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def create_event(event, message = '')
    execution.events.create_with_name!(event, message)
  end
end