# frozen_string_literal: true

require 'rails_helper'

describe BenchmarkSchedule do
  let(:schedule_file) { Rails.application.config.benchmark_schedule }
  context 'when schedule is inactive' do
    let(:schedule) { create(:benchmark_schedule, active: false) }
    before { FileUtils.rm_f(schedule_file) }
    describe 'activate schedule' do
      before do
        schedule.active = true
        schedule.save
      end
      it 'should add the cron expression to the schedule file' do
        expect(File.exist?(schedule_file)).to be true
        expect(File.read(schedule_file)).to include(schedule.cron_expression)
      end
    end
  end

  context 'when schedule is active' do
    let(:schedule) { create(:benchmark_schedule, active: true) }
    before { BenchmarkSchedule.update_system_crontab }
    describe 'inactivate schedule' do
      it 'should remove the cron expression from the schedule file' do
        expect(File.read(schedule_file)).not_to include(schedule.cron_expression)
      end
    end
  end
end
