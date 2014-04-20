#
# Cookbook Name:: cbench-databox
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

# Woraround for error in databox recipe where all databases get installed
# regardless of the provided configuration.
# See https://github.com/teohm/databox-cookbook/pull/6
# Set attribute to nil such that the conditional check in the original cookbook works.
mysql = node["databox"]["databases"]["mysql"]
if mysql || mysql.none?
  node.override["databox"]["databases"]["mysql"] = nil
end

postgresql = node["databox"]["databases"]["postgresql"]
if postgresql || postgresql.none?
  node.override["databox"]["databases"]["postgresql"] = nil
end

include_recipe "databox"