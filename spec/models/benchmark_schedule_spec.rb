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

  describe 'filtering schedules' do
    let(:active_schedule) { create(:benchmark_schedule, active: true) }
    let(:inactive_schedule) { create(:benchmark_schedule, active: false) }
    before do
      active_schedule.save!
      inactive_schedule.save!
    end
    it 'should show only active schedules' do
      expect(BenchmarkSchedule.actives.size).to eq 1
    end
  end
end
