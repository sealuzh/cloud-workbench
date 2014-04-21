# default["chef-server"]["fqdn"] = # Not known à priori! => reprovision or dynamically set in recipe
# For cloud config see running instance and http://stackoverflow.com/questions/19586040/install-chef-server-11-on-ec2-instance

default["chef-server"]["version"] = :latest

# chef-server.rb configuration
defaut["chef-server"]["configuration"] = {}
