#!/bin/bash 

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
  #############################################################################################
  "
fi
