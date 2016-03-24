# https://github.com/colszowka/simplecov#using-simplecov-for-centralized-config
# Maybe put some conditional here not to execute the code below unless ENV['COVERAGE'] == 'true'
# Lookup defaults: https://github.com/colszowka/simplecov/blob/master/lib/simplecov/defaults.rb
SimpleCov.start do
  load_profile 'test_frameworks'
  coverage_dir 'coverage'
  command_name 'MiniTest'
  merge_timeout 3600 # 1 hour
  track_files "{app,lib}/**/*.rb"

  # Groups
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  # add_group 'Mailers', 'app/mailers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Jobs', %w(app/jobs app/workers)
  add_group 'Libraries', 'lib'

  add_group 'Long files' do |src_file|
    src_file.lines.count > 100
  end
  class MaxLinesFilter < SimpleCov::Filter
    def matches?(source_file)
      source_file.lines.count < filter_argument
    end
  end
  add_group 'Short files', MaxLinesFilter.new(5)

  # Exclude these paths from analysis
  add_filter '/config/'
  add_filter '/db/'
  add_filter 'lib/plugins'
  add_filter 'vendor'
  add_filter 'bundle'
end
