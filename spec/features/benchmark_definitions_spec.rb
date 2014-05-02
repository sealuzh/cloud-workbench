require 'spec_helper'

feature "Benchmark definitions" do

  scenario "Listing benchmark definitions" do
    visit benchmark_definitions_path
    page.should have_link('Create New Benchmark', href: new_benchmark_definition_path)
  end

  scenario "Creating a valid benchmark definition" do
    valid_benchmark_definition = build(:benchmark_definition)
    visit new_benchmark_definition_path
    within("#new_benchmark_definition") do
      fill_in 'Name', with: valid_benchmark_definition.name
      fill_in 'vagrant_file_content', with: valid_benchmark_definition.vagrantfile
    end

    click_button 'Create Benchmark definition'
    page.should have_content 'Benchmark definition was successfully created'
    # TODO: decide about show and edit
    # page.should have_content valid_benchmark_definition.name
    have_field('Name', with: valid_benchmark_definition.name)
    page.should have_content valid_benchmark_definition.vagrantfile
    bm_definition = BenchmarkDefinition.find_by_name(valid_benchmark_definition.name)
    bm_definition.vagrantfile .should eq valid_benchmark_definition.vagrantfile
  end

  given(:existing_definition) { create(:benchmark_definition) }
  scenario "Creating an invalid benchmark definition" do
    same_name_definition = build(:benchmark_definition, name: existing_definition.name)
    visit new_benchmark_definition_path
    within("#new_benchmark_definition") do
      fill_in 'Name', with: same_name_definition.name
      fill_in 'vagrant_file_content', with: same_name_definition.vagrantfile
    end

    expect do
      click_button 'Create Benchmark definition'
    end.to change(BenchmarkDefinition, :count).by(0)
    page.should have_content 'Name already exists'
  end
end
