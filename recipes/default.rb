#
# Cookbook Name:: chef-server-image
# Recipe:: default
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

chef_path = "/opt/chef/bin"
temp_dir ||= Dir.mktmpdir

# install git
apt_package "git" do
end

# clone chef-repo
git "#{ENV['HOME']}/chef-repo/" do
  repository "node['chef-server-image'][chef-repo]"
  revision "master"
end

# download chef-server cookbook to chef-repo
bash "chef-server cookbook download" do
  cwd "#{temp_dir}"
  code <<-EOH
  sudo knife cookbook site download chef-server -f chef-server.tar.gz
  tar -xzf #{temp_dir}/chef-server.tar.gz -C "#{ENV['HOME']}/chef-repo/cookbooks/"
  EOH
end

# cleanup temp directory
directory "#{temp_dir}" do
  action :delete
end

# place chef-server-setup.sh to chef package dir
cookbook_file "chef-server-setup.sh" do
  path "#{chef_path}/chef-server-setup"
  mode "755"
  action :create
end

# create symlink for /chef/opt/bin/chef-server-setup.sh to /usr/bin/
link "#{chef_path}/chef-server-setup" do
  to "/usr/bin"
end

# creates attribute json file for chef-server cookbook
template "/etc/chef/chef-server-attribute.json" do
  source "chef-server-attribute.erb"
  action :create
end

cookbook_file "chef-server-setup-help.sh" do
  path "#{chef_path}/chef-server-setup-help.sh"
  mode "755"
  action :create
end

# writes chef-server setup help message to .bashrc
bash "update .bashrc to show chef-server configuration help" do
  cwd "#{ENV['HOME']}"
  code <<-EOH
  echo '#{chef_path}/chef-server-setup-help.sh' >> .bashrc
  EOH

  not_if { ::File.read("#{ENV['HOME']}/.bashrc").include?("#{chef_path}/chef-server-setup-help.sh") } 
end
