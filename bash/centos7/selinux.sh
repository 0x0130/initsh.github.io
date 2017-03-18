#!/bin/bash

# Edit 20170306
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/selinux.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh") || echo "$(date -Is) [ERROR]: Failed to load https://${v_github_dir}/functions.sh"

{
	LogInfo "Start \"${v_script_name}\"."
	
	LogInfo "Redirect."
	sudo curl -LRs "${v_github_dir}/centos6/selinux.sh" | bash
	
	LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
