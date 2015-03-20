# chef_server_image cookbook
This cookbook includes an LWRP `chef_server_image` for setting up and configuring chef-server. It creates the organisation and user for chef-server and also configures the Management UI.

Requirements
------------

### Platforms

Supported on Ubuntu 12.04

Resource/Provider
-----------------

### `chef_server_image`

Exposes a bash command `chef-server-setup` which sets up and configures chef-server on the node.

#### Actions

- :setup: exposes command `chef-server-setup`

#### Attribute Parameters

- `package_url`: package_url for chef-server.
- `api_fqdn`: set API FQDN
- `cloud_provider`: set the cloud provider. Default is `azure`
- `fqdn_type`: Allowed values are `internal` or `external`. Default is `internal`
- `package_version`: Specify package version.
- `package_name`: Specify package name. Default is `chef-server-core`
- `chef_server_configuration`: Configuration hash for chef server
- `opscode_ui_configuration`: Configuration hash for Opscode UI.
- `apt_repo_distribution`: Apt repository distribution

#### Examples

```ruby
# Basic chef-server setup and configuration
chef_server_image "chef_server_image setup" do
  action :setup
end
```

Usage
-----

After bootstrapping the node with `chef_server_image` cookbook, a message will be dispalyed on login to the node:

```
  Run following command to install and configure Chef Server
  $ sudo chef-server-setup -u <username> -p <password> -o <organizations-short-name>
  Example:
  sudo chef-server-setup -u sysadmin -p \$MYPASSWORD -o engineering
  Use -? option for additional customization options
```

Running the command specified above will configure chef-server.
