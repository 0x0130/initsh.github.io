#!/bin/bash

# Edit 20170403
set -eu
v_github_dir="raw.githubusercontent.com/initsh/initsh.github.io/master/bash"
v_script_name="centos7/certbot.sh"

# functions
curl -LRs "${v_github_dir}/functions.sh" | . /dev/stdin

{
    LogInfo "Start \"${v_script_name}\"."

    # checks
    curl -LRs "${v_github_dir}/check/centos7.sh" | . /dev/stdin
    curl -LRs "${v_github_dir}/check/root.sh"    | . /dev/stdin
    curl -LRs "${v_github_dir}/check/args.sh"    | . /dev/stdin

    # check args
    if [ -z "$(echo "$1" | egrep '[^@]+@[^@\.]+\.[^@\.]+')" ]
    then
        LogError "\$1 expect e-mail address."
        exit 1
    fi
    if [ -z "$(echo "$2" | egrep "^[0-9a-zA-Z\-\.]*[0-9a-zA-Z\-]+\.[a-z]+")" ]
    then
        LogError "\$2 expect web server's fqdn."
        exit 1
    fi

    # install utils epel-release
    curl -LRs "${v_github_dir}/centos7/utils.sh" | bash /dev/stdin
    curl -LRs "${v_github_dir}/centos7/epel.sh"  | bash /dev/stdin

    # install certbot
    if ! rpm --quiet -q certbot
    then
        LogInfo "bash# yum --enablerepo=extra,optional,epel -y install certbot"
        yum --enablerepo=extra,optional,epel -y install certbot 2>&1
        if ! rpm --quiet -q certbot
        then
            LogInfo "bash# yum --enablerepo=* -y install certbot"
            yum --enablerepo=* -y install certbot 2>&1
            if ! rpm -q certbot
            then
                LogError "Failed to install certbot."
                exit 1
            fi
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

        v_expect_num="$(expect <<__EOD__ 2>/dev/null | awk -F: '/standalone/{print $1}'
set timeout 10
spawn certbot certonly --agree-tos --email ${v_email_addr} -d ${v_fqdn} --preferred-challenges tls-sni-01
expect "(press 'c' to cancel): "
send "c\n"
__EOD__
)"

        set +e
        expect <<__EOD__ 2>&1
set timeout 10
spawn certbot certonly --agree-tos --email ${v_email_addr} -d ${v_fqdn} --preferred-challenges tls-sni-01
expect "(press 'c' to cancel): "
send "${v_expect_num}\n"
expect "(press 'c' to cancel): "
send "c\n"
interact
__EOD__
        set -eu

    else
        LogError "Port 443:tcp already used. Please stop daemon using port 443:tcp."
        exit 1
    fi

    # notice
    LogNotice "SSL Keys..."
    LogNotice "$(ls -dl "/etc/letsencrypt/live/${v_fqdn}/"*)"
    LogNotice "Please edit web server's conf for SSL Keys."

    LogInfo "End \"${v_script_name}\"."
} >>"${v_log_file}"


# EOF
