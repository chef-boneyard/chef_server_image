case node['platform']
when 'ubuntu'

  chef_server_image 'test_chef_server_image setup' do
    action :setup
    package_url 'https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/trusty/chef-server-core_12.0.4-1_amd64.deb'
  end

else
  Chef::Log.warn('chef_server_image recipes can only be run on the Ubuntu platform.')
end
