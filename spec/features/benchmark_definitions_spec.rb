require 'rails_helper'

feature 'Benchmark definition management' do
  given(:user) { create(:user) }
  before { sign_in(user) }

  feature 'Listing benchmark definitions' do
    scenario 'Should show a link to create a new benchmark' do
      visit benchmark_definitions_path
      expect(page).to have_link('Create New Benchmark', href: new_benchmark_definition_path)
    end

    scenario 'Should list the definitions in reverse chronological order' do
      first =  create(:benchmark_definition)
      second = create(:benchmark_definition)
      third = create(:benchmark_definition)
      visit benchmark_definitions_path

      within(:xpath, '//table/tbody/tr[1]/td[2]/a') do
        expect(page).to have_content(third.name)
      end

      within(:xpath, '//table/tbody/tr[3]/td[2]/a') do
        expect(page).to have_content(first.name)
      end
    end
  end

  feature 'Creating a benchmark definition' do
    background { visit new_benchmark_definition_path }

    scenario 'Should provide a sample Vagrantfile' do
      expect(find_field('Vagrantfile').value).to match(/.*Vagrant.configure.*/)
    end

    given(:valid_benchmark_definition) { build(:benchmark_definition) }
    scenario 'With valid information' do
      fill_in_create_form(valid_benchmark_definition)

      click_button 'Create New Benchmark'
      expect(page).to have_content 'was successfully created'
      expect(page).to have_field('Name', with: valid_benchmark_definition.name)
      expect(page).to have_field('Vagrantfile', with: valid_benchmark_definition.vagrantfile)
      bm_definition = BenchmarkDefinition.find_by_name(valid_benchmark_definition.name)
      expect(bm_definition.vagrantfile) .to eq valid_benchmark_definition.vagrantfile
    end

    given(:existing_definition) { create(:benchmark_definition) }
    scenario 'With invalid information' do
      same_name_definition = build(:benchmark_definition, name: existing_definition.name)
      visit new_benchmark_definition_path
      fill_in_create_form(same_name_definition)

      expect do
        click_button 'Create New Benchmark'
      end.to change(BenchmarkDefinition, :count).by(0)
      expect(page).to have_content 'has already been taken'
    end

    def fill_in_create_form(benchmark_definition)
      within('#new_benchmark_definition') do
        fill_in 'Name', with: benchmark_definition.name
        # The select option automatically capitalizes the first letter
        select benchmark_definition.provider_name.humanize, from: 'Provider name'
        fill_in 'Timeout for running benchmark', with: benchmark_definition.running_timeout
        fill_in 'Vagrantfile', with: benchmark_definition.vagrantfile
      end
    end
  end

  given(:existing_definition) { create(:benchmark_definition) }
  scenario 'Show a benchmark definition' do
    visit benchmark_definition_path(existing_definition)
    expect(page).to have_content existing_definition.name
  end

  feature 'Editing a benchmark definition' do
    given(:benchmark_definition) { create(:benchmark_definition) }
    background { visit edit_benchmark_definition_path(benchmark_definition) }

    context 'Without existing benchmark executions' do
      scenario 'Name field should be editable' do
        expect(page).not_to have_xpath("//input[@id='benchmark_definition_name' and @readonly='readonly']")
      end
    end

    context 'With existing benchmark executions' do
      background do
        benchmark_definition.start_execution_async
        visit edit_benchmark_definition_path(benchmark_definition)
      end

      scenario 'Name field should be readonly' do
        expect(page).to have_xpath("//input[@id='benchmark_definition_name' and @readonly='readonly']")
      end
    end

  end

  feature 'Editing a metric definition' do
    given(:ratio_metric) { create(:ratio_metric_definition, unit: 'wrong unit') }
    background { visit  edit_metric_definition_path(ratio_metric) }

    scenario 'Should change unit name' do
      fill_in 'Unit', with: 'MB/s'
      click_button 'Update Metric Definition'
      expect(page).to have_content('successfully updated')
      ratio_metric.reload
      expect(ratio_metric.unit).to eq('MB/s')
    end
  end

  feature 'Starting a benchmark execution' do
    given(:benchmark_definition) { create(:benchmark_definition) }
    given(:start_execution) { -> { click_button 'Start Execution'} }
    background { visit benchmark_definition_path(benchmark_definition) }

    scenario 'Should create a new benchmark execution' do
      expect(start_execution).to change(BenchmarkExecution, :count).by(1)
    end

    scenario 'Should schedule a job' do
      expect(start_execution).to change(Delayed::Job, :count).by(1)
    end

    scenario 'Should redirect to the newly created benchmark execution ' do
      start_execution.call
      execution = BenchmarkExecution.find_by_benchmark_definition_id(benchmark_definition.id)
      expect(current_path).to eq benchmark_execution_path(execution)
    end
  end
end
