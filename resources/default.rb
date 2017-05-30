actions :setup
default_action :setup

attribute :given_name, name_attribute: true
attribute :package_url, kind_of: String, default: nil
attribute :apt_repo_distribution, kind_of: String,
                                  default: node['chef']['addons']['ubuntu_supported_codenames'].include?(node['lsb']['codename']) ? node['lsb']['codename'] : 'lucid'
attribute :api_fqdn, kind_of: String, default: node['fqdn']
attribute :cloud_provider, kind_of: String, default: 'azure'
attribute :fqdn_type, kind_of: String, default: 'internal' # Valid values = external,internal
attribute :package_version, kind_of: String, default: ''
attribute :package_name, kind_of: String, default: 'chef-server-core'
attribute :chef_server_configuration, kind_of: Hash, default: {}
attribute :opscode_ui_configuration, kind_of: Hash, default: {}
