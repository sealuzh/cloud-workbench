require 'simplecov'

# Custom SimpleCov filter class from https://github.com/colszowka/simplecov
class LineFilter < SimpleCov::Filter
  def matches?(source_file)
    source_file.lines.count < filter_argument
  end
end

# The SimpleCov profile as shown below failed with undefined method 'profiles' error
# SimpleCov.profiles.define 'rails_custom' do
#   load_profile 'rails'
#   add_group "Long files" do |src_file|
#     src_file.lines.count > 100
#   end
#   add_group "Short files", LineFilter.new(10)
# end

# Workaround as long as profiles do not work
def configure_simple_cov
  add_group "Long files" do |src_file|
    src_file.lines.count > 100
  end
  add_group "Short files", LineFilter.new(10)
end