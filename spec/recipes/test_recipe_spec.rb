require 'spec_helper'
require 'chef'

recipe = "chef_server_image::test_recipe"

describe recipe do
  context "when windows" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform:'windows', version: '2012') do |node|
        node.set['lsb']['codename'] = "lucid"
        node.set['chef']['addons']['ubuntu_supported_codenames'] = "lucid"
      end.converge(described_recipe)
    end

    it "not to setup environment for chef-server" do
      ubuntu_distribution = "test_distro"
      expect(chef_run).to_not install_package("apt-transport-https")
      expect(chef_run).to_not add_apt_repository("chef-stable").with(
        uri: "https://packagecloud.io/chef/stable/ubuntu/", key: 'https://packagecloud.io/gpg.key',
        distribution: ubuntu_distribution, deb_src: true,
        trusted: true, components: ["main"])
      expect(chef_run).to_not include_recipe('apt::default')

      expect(chef_run).to_not create_template('/opt/chef/bin/chef-server-setup').with(
        source: 'chef-server-image.erb',
        owner: 'root',
        group: 'root',
        mode: '755')

      expect(chef_run).to_not create_link('usr/bin/chef-server-setup').with(to: '/opt/chef/bin/chef-server-setup')

      expect(chef_run).to_not run_bash('update .bashrc to show chef-server configuration help').with(
        cwd: "#{ENV['HOME']}" )

      expect(chef_run).to_not delete_directory('/etc/chef').with(recursive: true)
      expect(chef_run).to_not delete_directory('/var/chef').with(recursive: true)
    end
  end

  context "when ubuntu" do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['chef_server_image'],platform:'ubuntu', version: '12.04') do |node|
      end.converge(described_recipe)
    end

    it 'setup env' do
	expect(chef_run).to setup_chef_server_image('test_chef_server_image setup').with(package_url: "https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/trusty/chef-server-core_12.0.4-1_amd64.deb")
    end


    it 'setup environment for chef-server installation with package_url' do
      ubuntu_distribution = "test_distro"
      expect(chef_run).to_not install_package("apt-transport-https")
      expect(chef_run).to_not add_apt_repository("chef-stable").with(
        uri: "https://packagecloud.io/chef/stable/ubuntu/", key: 'https://packagecloud.io/gpg.key',
        distribution: ubuntu_distribution, deb_src: true,
        trusted: true, components: ["main"])
      expect(chef_run).to_not include_recipe('apt::default')

      expect(chef_run).to create_template('/opt/chef/bin/chef-server-setup').with(
        source: 'chef-server-image.erb',
        owner: 'root',
        group: 'root',
        mode: '755')

      expect(chef_run).to create_link('/usr/bin/chef-server-setup').with(to: '/opt/chef/bin/chef-server-setup')

      expect(chef_run).to run_bash('update .bashrc to show chef-server configuration help').with(
        cwd: "#{ENV['HOME']}" )

      expect(chef_run).to delete_directory('/etc/chef').with(recursive: true)
      expect(chef_run).to delete_directory('/var/chef').with(recursive: true)
    end

  end
end

