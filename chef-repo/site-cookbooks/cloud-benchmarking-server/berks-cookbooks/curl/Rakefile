require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

FoodCritic::Rake::LintTask.new

RSpec::Core::RakeTask.new(:unit) do |t|
  t.rspec_opts = [].tap do |a|
    a.push('--color')
    a.push('--format progress')
  end.join(' ')
end

Rubocop::RakeTask.new

task test: [:unit, :foodcritic, :rubocop]
task default: [:test]
