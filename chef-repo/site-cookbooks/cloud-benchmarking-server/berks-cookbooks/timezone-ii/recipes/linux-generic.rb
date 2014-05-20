#
# Cookbook Name:: timezone-ii
# Recipe:: linux-generic
#
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

# Generic timezone-changing method for Linux that should work for any distro
# without a platform-specific method.

timezone_data_file = File.join(node.timezone.tzdata_dir, node.tz)
localtime_path = node.timezone.localtime_path

ruby_block "confirm timezone" do
  block {
    unless File.exist?(timezone_data_file)
      raise "Can't find #{timezone_data_file}!"
    end
  }
end

if node.timezone.use_symlink
  link localtime_path do
    to timezone_data_file
    owner 'root'
    group 'root'
    mode 0644
  end

else
  file localtime_path do
    content File.open(timezone_data_file, 'rb').read
    owner 'root'
    group 'root'
    mode 0644
    not_if {
      File.symlink?(localtime_path) and
        Chef::Log.error "You must remove symbolic link at #{localtime_path}" +
                        " or set attribute ['timezone']['use_symlink']=true"
    }
  end
end  # if/else node.timezone.use_symlink

# vim:ts=2:sw=2:
