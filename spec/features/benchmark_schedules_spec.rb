# frozen_string_literal: true

require 'rails_helper'

feature 'Benchmark schedule' do
  given(:user) { create(:user) }
  before { sign_in(user) }

  feature 'listing schedules' do
    given(:active_schedule) { create(:benchmark_schedule, active: true) }
    given(:inactive_schedule) { create(:benchmark_schedule, active: false) }
    background do
      active_schedule.save!
      inactive_schedule.save!
      visit benchmark_schedules_path
    end

    scenario 'should display all schedules' do
      expect(page).to have_content active_schedule.benchmark_definition.name
      expect(page).to have_content inactive_schedule.benchmark_definition.name
    end

    feature 'filtering active schedules' do
      background { click_on(class: 'badge-total') }

      scenario 'should display only active schedules' do
        expect(page).to have_current_path(benchmark_schedules_path(active: 'true'))
        expect(page).to have_content active_schedule.benchmark_definition.name
        expect(page).to_not have_content inactive_schedule.benchmark_definition.name
      end
    end
  end

  feature 'creating a benchmark schedule' do
    given(:benchmark_definition) { create(:benchmark_definition) }
    background do
      visit benchmark_definition_path(benchmark_definition)
      click_link 'Create Schedule'
    end

    scenario 'should show the create schedule view' do
      expect(page).to have_content 'Create Schedule'
    end
    scenario 'should show a cron expression reference' do
      expect(page).to have_content 'Cron-Expression Reference'
    end
    scenario 'should show a flash after creation' do
      fill_in 'Cron expression', with: '15 * * * *'
      click_button 'Create Schedule'
      expect(page).to have_content "Schedule for #{benchmark_definition.name} was successfully created"
    end
  end

  feature 'editing a benchmark schedule' do
    given(:schedule) { create(:benchmark_schedule, active: false) }
    background { visit edit_benchmark_schedule_path(schedule) }

    scenario 'should show a cron expression reference' do
      expect(page).to have_content 'Cron-Expression Reference'
    end
    scenario 'should show a flash after editing' do
      click_button 'Update Schedule'
      expect(page).to have_content "Schedule for #{schedule.benchmark_definition.name} was successfully updated"
    end
  end

  feature 'activating a benchmark schedule' do
    given(:inactive_schedule) { create(:benchmark_schedule, active: false) }
    background { visit benchmark_definition_path(inactive_schedule.benchmark_definition) }

    scenario 'should show a flash after activating' do
      find('a', text: /Activate Schedule/).click
      expect(page).to have_content "Schedule for #{inactive_schedule.benchmark_definition.name} was successfully activated"
    end
  end

  feature 'deactivating a benchmark schedule' do
    given(:active_schedule) { create(:benchmark_schedule, active: true) }
    background { visit benchmark_definition_path(active_schedule.benchmark_definition) }

    scenario 'should show a flash after activating' do
      find('a', text: /Deactivate Schedule/).click
      expect(page).to have_content "Schedule for #{active_schedule.benchmark_definition.name} was successfully deactivated"
    end
  end
end
