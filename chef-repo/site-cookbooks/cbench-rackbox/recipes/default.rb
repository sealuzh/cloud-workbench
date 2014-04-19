#
# Cookbook Name:: cbench-rackbox
# Recipe:: default
#
# Copyright (C) 2014 seal uzh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Woraround for error in rackbox recipe where all apps get installed
# regardless of the provided configuration.
# Set attribute to nil such that the conditional check in the original cookbook works.
if node["rackbox"]["apps"]["unicorn"].none?
  node.set["rackbox"]["apps"]["unicorn"] = nil
end

if node["rackbox"]["apps"]["passenger"].none?
  node.set["rackbox"]["apps"]["passenger"] = nil
end

# Use a custom runit template for unicorn: `sv-cbench-unicorn-run.erb`
node.default["rackbox"]["default_config"]["unicorn_runit"]["template_name"] = "cbench-unicorn"

include_recipe "rackbox"