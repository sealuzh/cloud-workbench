require 'spec_helper'

feature "Benchmark definition management" do

  scenario "Listing benchmark definitions" do
    visit benchmark_definitions_path
    page.should have_link('Create New Benchmark', href: new_benchmark_definition_path)
  end

  feature "Creating a benchmark definition" do
    background { visit new_benchmark_definition_path }

    scenario "Should provide a sample Vagrantfile" do
      expect(find_field('Vagrantfile').value).to match(/.*Vagrant.configure.*/)
    end

    scenario "With valid information" do
      valid_benchmark_definition = build(:benchmark_definition)
      fill_in_create_form(valid_benchmark_definition)

      click_button 'Create New Benchmark'
      page.should have_content 'Benchmark definition was successfully created'
      page.should have_field('Name', with: valid_benchmark_definition.name)
      page.should have_field('Vagrantfile', with: valid_benchmark_definition.vagrantfile)
      bm_definition = BenchmarkDefinition.find_by_name(valid_benchmark_definition.name)
      bm_definition.vagrantfile .should eq valid_benchmark_definition.vagrantfile
    end

    given(:existing_definition) { create(:benchmark_definition) }
    scenario "With invalid information" do
      same_name_definition = build(:benchmark_definition, name: existing_definition.name)
      visit new_benchmark_definition_path
      fill_in_create_form(same_name_definition)

      expect do
        click_button 'Create New Benchmark'
      end.to change(BenchmarkDefinition, :count).by(0)
      page.should have_content 'has already been taken'
    end

    def fill_in_create_form(benchmark_definition)
      within("#new_benchmark_definition") do
        fill_in 'Name', with: benchmark_definition.name
        fill_in 'Vagrantfile', with: benchmark_definition.vagrantfile
      end
    end
  end

  given(:existing_definition) { create(:benchmark_definition) }
  scenario "Show a benchmark definition" do
    visit benchmark_definition_path(existing_definition)
    page.should have_content existing_definition.name

    pending("should list vm instances")
  end

  feature "Editing a benchmark definition" do
    given(:benchmark_definition) { create(:benchmark_definition) }
    background { visit edit_benchmark_definition_path(benchmark_definition) }

    context "Without existing benchmark executions" do
      scenario "Name field should be editable" do
        page.should_not have_xpath("//input[@id='benchmark_definition_name' and @readonly='readonly']")
      end
    end

    context "With existing benchmark executions" do
      background do
        benchmark_definition.start_execution_async
        visit edit_benchmark_definition_path(benchmark_definition)
      end

      scenario "Name field should be readonly" do
        page.should have_xpath("//input[@id='benchmark_definition_name' and @readonly='readonly']")
      end
    end

  end

  feature "Starting a benchmark execution" do
    given(:benchmark_definition) { create(:benchmark_definition) }

    context "Within editing a benchmark definition" do
      background { visit edit_benchmark_definition_path(benchmark_definition) }
      given(:start_execution) { -> { click_button 'Start Execution'} }

      scenario "Should create a new benchmark execution" do
        expect(start_execution).to change(BenchmarkExecution, :count).by(1)
      end

      scenario "Should schedule a job" do
        expect(start_execution).to change(Delayed::Job, :count).by(1)
      end

      scenario "Should redirect to the newly created benchmark execution " do
        start_execution.call
        execution = BenchmarkExecution.find_by_benchmark_definition_id(benchmark_definition.id)
        expect(current_path).to eq benchmark_execution_path(execution)
      end
    end
  end
end
