#!/bin/bash 

# Display chef-server-setup options usage help
usage() { echo "Usage: $0 [-u <administrator-name>] [-p <administrator-password>] [-f <user-full-name>] [-l <user-last-name>] [-e <email-id>] [-o <organization-name>] [-o <organization-full-name>]" 1>&2; exit 1; }

# Check last run command status.
# $1 => "Error message"
checkStatus() {
  if [ $? -ne 0 ]; then
    echo "Error: $1"
    exit 1
  fi
}

## Take chef server configuration from user
while getopts ":u:f:l:e:p:o:F:" opt; do
  case "${opt}" in
    u)
      user=${OPTARG}
      ;;
    f)
      userFirstName=${OPTARG}
      ;;
    l)
      userLastName=${OPTARG}
      ;;
    e)
      email=${OPTARG}
      ;;
    p)
      password=${OPTARG}
      ;;
    o)
      orgShortName=${OPTARG}
      ;;
    F)
      orgFullName=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done

shift $((OPTIND-1))

# Prompt if user missed any option.
if [ -z "${user}" ];then
  echo "Enter user name for chef-server:"
  read user
fi

if [ -z "${userFirstName}" ];then
  userFirstName=$user
fi

if [ -z "${userLastName}" ];then
  userLastName=$user
fi

if [ -z "${email}" ];then
  email="default@testdefault.com"
fi

if [ -z "${password}" ];then
  echo "Enter secure password for user:"
  read password
fi

if [ -z "${orgShortName}" ];then
  orgShortName="${user}organization"
fi

if [ -z "${orgFullName}" ];then
  orgShortName="${user}organization"
fi

if [ -z "${user}" ] || [ -z "${userFirstName}" ] || [ -z "${userLastName}" ] || [ -z "${email}" ] || [ -z "${password}" ] || [ -z "${orgShortName}" ] || [ -z "${orgFullName}" ]; then
  usage
fi

## Start Chef Server Installation
#sudo chef-client -z <path-to-chef-server-cookbook-default-recipe> -j /etc/chef/chef-server-pkg.json 

echo "Installing chef-server..."
cd ~/chef-repo
sudo chef-client -z -o chef-server -j /etc/chef/chef-server-pkg.json
checkStatus "Error: Chef-Server Installation fails. Please try again"
echo "Chef-Server installed successfully"

## Create user
echo "Creating new admin user for chef-server..."
sudo chef-server-ctl user-create $user $userFirstName $userLastName $email $password --filename /etc/chef-server/$user.pem
checkStatus "Error: Chef-Server user creation fails. Please try again"
echo "Admin user created for chef-server. RSA private key for user stored at: /etc/chef-server/$user.pem"

## Create org for above user
echo "Creating new organization for admin user"
sudo chef-server-ctl org-create $orgShortName $orgFullName --association_user $user --filename /etc/chef-server/$orgShortName-validator.pem

checkStatus "Error: Chef-Server organization creation fails. Please try again"
echo "New organization created for chef-server. RSA private key for organization stored at: /etc/chef-server/$orgShortName-validator.pem"

## Install Webui
echo "Installing Management Console (i.e web portal) for Chef Server..."
sudo chef-server-ctl install opscode-manage

checkStatus "Error: Management Console installation failed!!! Please try again"
echo "Installed Webui for Chef Server"

## configure webui
echo "Configuring Chef Server's Webui..."
sudo opscode-manage-ctl reconfigure
checkStatus "Error: Unable to configure webui"
echo "Configured Chef Server's Webui"

## reconfigure chef-server for Webui
echo "Reconfiguring chef-server for Webui..."
sudo chef-server-ctl reconfigure
checkStatus "Error: Unable to reconfigure chef-server"
echo "Reconfigured chef-server for Webui"

echo "Successfully Installed Chef Server v12.0 !!!"
echo "USER NAME = ${user}"
echo "PASSWORD = ${password}"
echo "ORGANIZATION = ${orgShortName}"
echo "USER PRIVATE_KEY = /etc/chef-server/$user.pem"
echo "ORGANIZATION PRIVATE_KEY = /etc/chef-server/$orgShortName-validator.pem"

echo "Webui URL = "; cat /etc/chef-server/chef-server.rb | grep api_fqdn | awk '{print $2}'
