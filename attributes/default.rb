#
# Cookbook Name:: chef-server
# Attributes:: default
#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## Todo: generate it through api when Omnitruck API issue(i.e It doesn't give latest chef-server package) resolved
default['chef-server']['package_file'] = "https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/precise/chef-server-core_12.0.0-1_amd64.deb"
default['chef-server-image']['chef-repo'] = "https://github.com/opscode/chef-repo.git"