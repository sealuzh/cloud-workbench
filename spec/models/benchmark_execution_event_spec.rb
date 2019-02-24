# frozen_string_literal: true

require 'rails_helper'

# include DurationModule
include TimeDiff::Matchers
describe 'Events of benchmark execution' do
  let(:execution) { create(:benchmark_execution) }
  before { create_event(:created) }
  subject { execution }

  its(:active?) { should be_truthy }
  describe 'duration' do
    its(:duration) { should be > 0 }
    specify { expect{execution.duration}.to increase_over_time }
  end

  context 'after started preparing,' do
    before { create_event(:started_preparing) }

    context 'finished preparing,' do
      before { create_event(:finished_preparing) }
      its(:benchmark_active?) { should be_falsey }
      describe 'benchmark duration' do
        its(:benchmark_duration) { should eq 0 }
        specify { expect{execution.benchmark_duration}.to remain_over_time }
      end

      context 'started running,' do
        before { create_event(:started_running) }
        its(:benchmark_active?) { should be_truthy }
        describe 'benchmark duration' do
          its(:benchmark_duration) { should be > 0 }
          specify { expect{execution.benchmark_duration}.to increase_over_time }
        end

        context 'finished running,' do
          before { create_event(:finished_running) }
          its(:benchmark_active?) { should be_falsey }
          describe 'benchmark duration' do
            specify { expect{execution.benchmark_duration}.to remain_over_time }
          end

          context 'started_postprocessing,' do
            before { create_event(:started_postprocessing) }

            context 'finished_postprocessing,' do
              before { create_event(:finished_postprocessing) }

              context 'started_releasing_resources,' do
                before { create_event(:started_releasing_resources) }
                its(:active?) { should be_truthy }

                context 'finished_releasing_resources' do
                  before { create_event(:finished_releasing_resources) }
                  its(:active?) { should be_falsey }
                  describe 'execution duration' do
                    specify { expect{execution.duration}.to remain_over_time }
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
