#!/bin/bash

# Edit 20170306
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/certbot.sh"

# functions
. <(curl -LRs "${v_github_dir}/functions.sh") || echo "$(date -Is) [ERROR]: Failed to load https://${v_github_dir}/functions.sh"

{
	LogInfo "Start \"${v_script_name}\"."
	
	# checks
	. <(curl -LRs "${v_github_dir}/check/centos7.sh")
	. <(curl -LRs "${v_github_dir}/check/root.sh")
	. <(curl -LRs "${v_github_dir}/check/args.sh")
	
	# check args
	if [ -z "$(echo "$1" | egrep '[^@]+@[^@\.]+\.[^@\.]+')" ]
	then
		LogError "\$1 needs e-mail address."
		exit 1
	fi
	if [ -z "$(echo "$2" | egrep '[^\.]+\.[^\.]+')" ]
	then
		LogError "\$2 needs web server's fqdn."
		exit 1
	fi
	
	# install utils epel-release
	bash <(curl -LRs "${v_github_dir}/centos7/utils.sh")
	bash <(curl -LRs "${v_github_dir}/centos7/epel.sh")
	
	# install certbot
	if ! rpm --quiet -q certbot
	then
		LogInfo "bash# yum --enablerepo=* -y install certbot"
		yum --enablerepo=* -y install certbot 2>&1
		LogInfo "bash# yum --enablerepo=extra,optional,epel -y install certbot"
		yum --enablerepo=extra,optional,epel -y install certbot 2>&1
		if ! rpm -q certbot
		then
			LogError "Failed to install certbot."
			exit 1
		fi
	fi
	
	# variables
	v_email_addr="$1"
	v_fqdn="$2"
	
	# install cert
	if [ -z "$(ss -lntp | awk '$0=$4' | egrep '443$')" ]
	then
		LogInfo "Generate SSL Keys."
		LogInfo "$(echo '{"v_email_addr": "'"${v_email_addr}"'", "v_fqdn": "'"${v_fqdn}"'"}' | jq .)"
		
		v_expect_num="$(expect <<__EOD__ | awk -F: '/standalone/{print $1}'
set timeout 10
spawn certbot certonly --agree-tos --email ${v_email_addr} -d ${v_fqdn} --preferred-challenges tls-sni-01
expect "(press 'c' to cancel): "
send "c\n"
__EOD__
)"
		
		expect <<__EOD__
set timeout 10
spawn certbot certonly --agree-tos --email ${v_email_addr} -d ${v_fqdn} --preferred-challenges tls-sni-01
expect "(press 'c' to cancel): "
send "${v_expect_num}\n"
expect "(press 'c' to cancel): "
send "c\n"
interact
__EOD__
		
	else
		if [ -z "$(echo "$3" | egrep '^/[^/]*')" ]
		then
			v_web_server="$(ss -lntp | awk '{print $6,$4}' | egrep '443$' | sed -r -e 's/users:\(\("([^"]*)".*/\1/g')"
			LogError "\$3 needs web server's document root..."
			LogError "OR run the following command."
			LogError "bash# certbot certonly --agree-tos --email ${v_email_addr} -d ${v_fqdn} --preferred-challenges tls-sni-01 --pre-hook \"systemctl stop ${v_web_server}\" --post-hook \"systemctl start ${v_web_server}\""
			exit 1
		fi
		
		# variables
		v_fqdn_docroot="$3"
		
		LogInfo "Generate SSL Keys."
		LogInfo "$(echo '{"v_email_addr": "'"${v_email_addr}"'", "v_fqdn": "'"${v_fqdn}"'", "v_fqdn_docroot": "'"${v_fqdn_docroot}"'"}' | jq .)"
		
		expect <<__EOD__
set timeout 10
spawn certbot certonly --agree-tos --email ${v_email_addr} --webroot -w ${v_fqdn_docroot} -d ${v_fqdn} --preferred-challenges tls-sni-01
expect "(press 'c' to cancel): "
send "c\n"
interact
__EOD__
	
	fi
	
	# notice
	LogNotice "SSL Keys..."
	LogNotice "$(ls -dl "/etc/letsencrypt/live/${v_fqdn}/"*)"
	LogNotice "Please edit web server's conf for SSL Keys."
	
	LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
