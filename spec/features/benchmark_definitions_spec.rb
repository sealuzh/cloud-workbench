require 'spec_helper'

feature "Benchmark definitions" do

  scenario "Listing benchmark definitions" do
    visit benchmark_definitions_path
    page.should have_link('Create New Benchmark', href: new_benchmark_definition_path)
  end

  scenario "Creating a valid benchmark definition" do
    valid_benchmark_definition = build(:benchmark_definition)
    visit new_benchmark_definition_path
    expect(find_field('Vagrantfile').value).to match(/.*Vagrant.configure.*/)
    within("#new_benchmark_definition") do
      fill_in 'Name', with: valid_benchmark_definition.name
      fill_in 'Vagrantfile', with: valid_benchmark_definition.vagrantfile
    end

    click_button 'Create New Benchmark'
    page.should have_content 'Benchmark definition was successfully created'
    # TODO: decide about show and edit
    # page.should have_content valid_benchmark_definition.name
    page.should have_field('Name', with: valid_benchmark_definition.name)
    # page.should have_content valid_benchmark_definition.vagrantfile
    page.should have_field('Vagrantfile', with: valid_benchmark_definition.vagrantfile)
    bm_definition = BenchmarkDefinition.find_by_name(valid_benchmark_definition.name)
    bm_definition.vagrantfile .should eq valid_benchmark_definition.vagrantfile
  end

  given(:existing_definition) { create(:benchmark_definition) }
  scenario "Creating an invalid benchmark definition" do
    same_name_definition = build(:benchmark_definition, name: existing_definition.name)
    visit new_benchmark_definition_path
    within("#new_benchmark_definition") do
      fill_in 'Name', with: same_name_definition.name
      fill_in 'Vagrantfile', with: same_name_definition.vagrantfile
    end

    expect do
      click_button 'Create New Benchmark'
    end.to change(BenchmarkDefinition, :count).by(0)
    page.should have_content 'has already been taken'
  end

  scenario "Show a benchmark definition" do
    visit benchmark_definition_path(existing_definition)
    page.should have_content existing_definition.name

    pending("should list vm instances")
  end

  context "Editing a benchmark definition" do
    given(:benchmark_definition) { create(:benchmark_definition) }
    background { visit edit_benchmark_definition_path(benchmark_definition) }
    given(:start_execution) { -> { click_button 'Start Execution'} }

    scenario "Start an execution should create a new benchmark execution" do
      expect(start_execution).to change(BenchmarkExecution, :count).by(1)
    end

    scenario "Start an execution should schedule a job" do
      expect(start_execution).to change(Delayed::Job, :count).by(1)
    end

    scenario "Start an execution should redirect to the newly created benchmark execution " do
      start_execution.call
      execution = BenchmarkExecution.find_by_benchmark_definition_id(benchmark_definition.id)
      expect(current_path).to eq benchmark_execution_path(execution)
    end
  end
end
