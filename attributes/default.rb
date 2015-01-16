#
# Cookbook Name:: chef-server-image
# Attributes:: default
#
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
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
default['chef-server-image']['package_name'] = "chef-server"
default['chef-server-image']['package_version'] = ""
default['chef-server-image']['package_url'] = "https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/precise/chef-server-core_12.0.0-1_amd64.deb"
default['chef']['install_path'] = "/opt/opscode"
default['chef-server']['configuration'] = {}
default['chef']['addons']['ubuntu_supported_codenames'] =  %w{lucid natty precise}
default['chef']['addons']['ubuntu_distribution'] =  node['chef']['addons']['ubuntu_supported_codenames'].include?(node['lsb']['codename']) ? node['lsb']['codename'] : 'lucid'