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

case node['platform']
when 'ubuntu'

  unless node['chef-server-image']['package_url']
    package "apt-transport-https"

    apt_repository 'chef-stable' do
      uri "https://packagecloud.io/chef/stable/ubuntu/"
      key 'https://packagecloud.io/gpg.key'
      distribution node['chef']['addons']['ubuntu_distribution']
      deb_src true
      trusted true
      components %w( main )
    end

    # Performs an apt-get update
    include_recipe 'apt::default'
  end

  chef_path = "/opt/chef/bin"
  
  template "#{chef_path}/chef-server-setup" do
    source 'chef-server-image.erb'
    owner 'root'
    group 'root'
    mode '755'
    action :create
  end

  # create symlink for /chef/opt/bin/chef-server-setup.sh to /usr/bin/
  link "/usr/bin/chef-server-setup" do
    to "#{chef_path}/chef-server-setup"
  end

  bash "update .bashrc to show chef-server configuration help" do
    cwd "#{ENV['HOME']}"
    code <<-EOH
    sudo echo '
     sudo chef-server-ctl status opscode-erchef | grep "run: opscode-erchef"
     if [ $? -ne 0 ]; then
       echo "
        #############################################################################################
        ### Run following command to install and configure Chef Server
        ### $ chef-server-setup -u <user-name> -f <user-first-name> -l <user-last-name> -e <email-id>
        ###   -p <password> -o <organizations-short-name> -F <organizations-full-name>
        #############################################################################################"
     else
       echo "
        #############################################################################################
        ### Run following command to configure Chef Server
        ### $ chef-server-ctl
        ###
        #############################################################################################"
     fi
     ' >> ~/.bashrc
    EOH
  end
  # Delete chef config files.
  %w{/etc/chef /var/chef}.each do |chef_dir|
    directory "#{chef_dir}" do
      recursive true
      action :delete
    end
  end
else
  Chef::Log.warn('chef-server-image recipes can only be run on the Ubuntu platform.')
end
