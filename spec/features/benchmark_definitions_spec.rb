require 'spec_helper'

feature "Benchmark definitions" do

  scenario "listing benchmark definitions" do
    visit '/benchmark_definitions'
    expect(page).to have_link('Create New Benchmark', new_benchmark_definition_path)
  end
end
