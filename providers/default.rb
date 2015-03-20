action :setup  do

 unless new_resource.package_url
    package "apt-transport-https"

    apt_repository 'chef-stable' do
      uri "https://packagecloud.io/chef/stable/ubuntu/"
      key 'https://packagecloud.io/gpg.key'
      distribution new_resource.apt_repo_distribution
      deb_src false
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
    variables({
     :api_fqdn => new_resource.api_fqdn,
     :cloud_provider => new_resource.cloud_provider,
     :fqdn_type => new_resource.fqdn_type,
     :package_url => new_resource.package_url,
     :package_version => new_resource.package_version,
     :package_name => new_resource.package_name,
     :chef_server_configuration => new_resource.chef_server_configuration,
     :opscode_ui_configuration => new_resource.opscode_ui_configuration
    })
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
     sudo chef-server-ctl status opscode-erchef 2> /dev/null | grep "run: opscode-erchef"
     if [ $? -ne 0 ]; then
       echo "
        #############################################################################################
        ## Run following command to install and configure Chef Server
        ## $ sudo chef-server-setup -u <username> -p <password> -o <organizations-short-name>
        ## Example:
        ##   sudo chef-server-setup -u sysadmin -p \$MYPASSWORD -o engineering
        ## Use -? option for additional customization options
        #############################################################################################"
     else
       echo "
        #############################################################################################
        ## Run following command to configure Chef Server
        ## $ chef-server-ctl
        ## Use -? option for additional customization options
        #############################################################################################"
     fi
     ' >> /etc/bash.bashrc
    EOH
  end

  # Delete chef config files.
  %w{/etc/chef /var/chef}.each do |chef_dir|
    directory "#{chef_dir}" do
      recursive true
      action :delete
    end
  end

end