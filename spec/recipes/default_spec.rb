require 'spec_helper'
require 'chef'

recipe = "chef-server-image::default"

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
      ChefSpec::SoloRunner.new(platform:'ubuntu', version: '12.04') do |node|
      end.converge(described_recipe)
    end

    it 'setup environment for chef-server installation on missing package_url' do
      chef_run.node.set['chef-server-image']['package_url'] = false
      ubuntu_distribution = "test_distro"
      chef_run.node.set['chef']['addons']['ubuntu_distribution'] = ubuntu_distribution
      chef_run.converge(described_recipe)

      expect(chef_run).to install_package('apt-transport-https')
      expect(chef_run).to add_apt_repository("chef-stable").with(
        uri: "https://packagecloud.io/chef/stable/ubuntu/", key: 'https://packagecloud.io/gpg.key',
        distribution: ubuntu_distribution, deb_src: true,
        trusted: true, components: ["main"])
      expect(chef_run).to include_recipe('apt::default')

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

    it 'setup environment for chef-server installation with package_url' do
      chef_run.node.set['chef-server-image']['package_url'] =  "https://chef-server-package-url"
      chef_run.converge(described_recipe)
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
