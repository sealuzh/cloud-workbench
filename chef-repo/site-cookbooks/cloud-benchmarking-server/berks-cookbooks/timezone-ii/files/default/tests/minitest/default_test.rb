require 'minitest/spec'

class TimezoneIiSpec < MiniTest::Chef::Spec

    describe_recipe 'timezone-ii::default' do
        localtime_path = '/etc/localtime'
        #original_tz_data_path = "/usr/share/zoneinfo/#{node[:tz]}"
        original_tz_data_path = "/usr/share/zoneinfo/Africa/Timbuktu"

        describe localtime_path do
            it "has the same data as #{original_tz_data_path}" do
                localtime_data = File.read(localtime_path)
                original_data =  File.read(original_tz_data_path)
                localtime_data.must_equal original_data
            end
        end

    end

end
