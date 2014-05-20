#
# Cookbook Name:: timezone-ii
# Recipe:: default
#
# Copyright 2010, James Harton <james@sociable.co.nz>
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

# Make sure the tzdata database is installed. (Arthur David Olson, the computer
# timekeeping field is forever in your debt.)
package value_for_platform_family(
  'gentoo'  => 'timezone-data',
  'default' => 'tzdata'
)

case node.platform_family
when 'debian', 'fedora'
  include_recipe "timezone-ii::#{node.platform_family}"

else
  if node.os == "linux"
    # Load the generic Linux recipe if there's no better known way to change the
    # timezone.  Log a warning (unless this is known to be the best way on a
    # particular platform).
    message = "Linux platform '#{node.platform}' is unknown to this recipe; " +
              "using generic Linux method"
    log message do
      level :warn
      not_if { %w( centos gentoo rhel ).include? node.platform_family }
    end

    include_recipe 'timezone-ii::linux-generic'

  else
    message = "Don't know how to configure timezone for " +
              "'#{node.platform_family}'!"
    log message do
      level :error
    end

  end  # if/else node.os

end  # case node.platform_family

# vim:ts=2:sw=2:
