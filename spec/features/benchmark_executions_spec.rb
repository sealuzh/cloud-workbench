# frozen_string_literal: true

require 'rails_helper'

feature 'Benchmark execution' do
  given(:user) { create(:user) }
  before { sign_in(user) }

  feature 'Listing' do
    given(:e1) { create(:benchmark_execution) }
    given(:e2) { create(:benchmark_execution) }
    background do
      e1.save!
      e2.save!
      visit benchmark_executions_path
    end

    scenario 'Should show all benchmark executions' do
      # -1 because of the header row
      expect(find('.table').all('tr').size - 1).to eq 2
    end
  end

  feature 'Showing a benchmark execution' do
    given(:benchmark_execution) { create(:benchmark_execution) }
    background { visit benchmark_execution_path(benchmark_execution) }

    scenario 'Should show view and edit links to the benchmark definition' do
      expect(page).to have_link(benchmark_execution.benchmark_definition.name)
      expect(page).to have_link('', href: edit_benchmark_definition_path(benchmark_execution.benchmark_definition))
    end
  end
end
