require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

def load_current_resource
  @current_resource = Chef::Resource::VagrantBox.new(new_resource)
  vb = shell_out('vagrant box list')
  if vb.stdout.include?(new_resource.box_name)
    @current_resource.installed(true)
  end
  @current_resource
end

action :install do
  unless installed?
    box_args = ''
    box_args += "#{new_resource.uri}" if new_resource.uri
    shell_out(
      "vagrant box add #{new_resource.box_name} #{box_args}",
      :user => new_resource.user
      )
    new_resource.updated_by_last_action(true)
  end
end

action :remove do
  uninstall if @current_resource.installed
  new_resource.updated_by_last_action(true)
end

action :uninstall do
  uninstall if @current_resource.installed
  new_resource.updated_by_last_action(true)
end

def uninstall
  shell_out("vagrant box remove #{new_resource.box_name}")
end

def installed?
  @current_resource.installed
end
