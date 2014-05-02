require 'spec_helper'

feature "Benchmark definitions" do

  scenario "listing benchmark definitions" do
    visit '/benchmark_definitions'
    page.should have_link('Create New Benchmark', href: new_benchmark_definition_path)
  end
end
