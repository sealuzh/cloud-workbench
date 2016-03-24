require 'spec_helper'

describe Event do
  let(:benchmark_execution) { create(:benchmark_execution) }
  let(:event) { benchmark_execution.events.create_with_name!(:created) }

  subject { event }

  it { is_expected.to be_valid }
  its(:failed?) { should be_falsey }
  its(:status) { should eq('WAITING FOR START PREPARING') }

end