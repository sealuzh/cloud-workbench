#
# Cookbook Name:: cbench-databox
# Recipe:: default
#
#

# Woraround for error in databox recipe where all databases get installed regardless of the provided configuration. See https://github.com/teohm/databox-cookbook/pull/6
# Set attribute to nil such that the conditional check in the original cookbook works.
if node["databox"]["databases"]["mysql"].none?
  node.set["databox"]["databases"]["mysql"] = nil
end

if node["databox"]["databases"]["postgresql"].none?
  node.set["databox"]["databases"]["postgresql"] = nil
end

include_recipe "databox"