include_recipe "database::mysql"

# set up mysql-server
mysql_service 'default' do
  version '5.5'
  port '3307'
  allow_remote_root false
  remove_anonymous_users false
  remove_test_database true
  server_root_password 'root'
  action :create
end

# create a mysql database
mysql_database 'benchmark' do
  connection ({:host => "localhost", :username => 'root', :password => 'root'})
  action :create
end