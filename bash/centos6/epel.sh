#!/bin/bash

# Edit 20170306
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos6/epel.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh") || echo "$(date -Is) [ERROR]: Failed to load https://${v_github_dir}/functions.sh"

{
	LogInfo "Start \"${v_script_name}\"."
	
	# checks
	. <(curl -LRs "${v_github_dir}/check/centos6.sh")
	. <(curl -LRs "${v_github_dir}/check/root.sh")
	
	# variable
	v_epel_url="https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm"
	
	# install yum-utils
	if ! rpm --quiet -q yum-utils
	then
		LogInfo "bash# yum -y install yum-utils"
		yum -y install yum-utils
	fi
	
	# install epel-release
	if ! rpm --quiet -q epel-release
	then
		LogInfo "bash# yum -y install ${v_epel_url}"
		yum -y install "${v_epel_url}"
		LogInfo "bash# yum-config-manager --disable epel*"
		yum-config-manager --disable epel*
	fi
	
	LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
