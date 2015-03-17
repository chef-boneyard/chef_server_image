#
# Cookbook Name:: chef_server_image
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
default['chef_server_image']['package_url'] = "https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/trusty/chef-server-core_12.0.4-1_amd64.deb"
default['chef']['addons']['ubuntu_supported_codenames'] =  %w{lucid natty precise}