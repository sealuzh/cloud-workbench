require 'rails_helper'

feature 'Benchmark execution' do
  given(:user) { create(:user) }
  before { sign_in(user) }

  feature 'Showing a benchmark execution' do
    given(:benchmark_execution) { create(:benchmark_execution) }
    background { visit benchmark_execution_path(benchmark_execution) }

    scenario 'Should show view and edit links to the benchmark definition' do
      expect(page).to have_link(benchmark_execution.benchmark_definition.name)
      expect(page).to have_link('', href: edit_benchmark_definition_path(benchmark_execution.benchmark_definition))
    end
  end
end
