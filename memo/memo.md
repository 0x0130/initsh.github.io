## edit PS1 for timestamp
    [ "$(echo "$PS1" | grep date)" ] || PS1="$(echo "$PS1" | sed -r -e 's/\\h/\\h $(date +%H:%M:%S)/g')"

## useradd admin
    USERNAME=""
    USERID=""
    groupadd -g "$USERID" "$USERNAME"
    useradd -u "$USERID" -g "$USERID" "$USERNAME"
    usermod -G wheel "$USERNAME"
    echo -e "# Edit 20170303\n${USERNAME} ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/"$USERNAME"
    [ -d "$(su "$USERNAME" -c 'echo "$HOME"/.ssh')" ] || su "$USERNAME" -c 'mkdir -m 700 "$HOME"/.ssh'
    [ "$(grep "$USERNAME" "$(su "$USERNAME" -c 'echo "$HOME"/.ssh/authorized_keys')" 2>/dev/null)" ] || echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAiY5TMcDeniTRzrhf+gL0Ma8Bm0Jn33XUUAmzNZ2InY/G08kFV7K3MHuKX47tf1/mCg7cRKrfZ6IkCr7jzvoD28sNVM74ZMatj5KV1NmPHJttjTH4ThozMtbQRWR8tUlkj+wppv5sHaFipq73GMUZrX5RcQPdFJqYFDCUSVoIP94d/DoStWXOvMxfld8GNLLpY3pTfqOMiQDST4LvixwYVBo1lHt0LF8lp8qH4uRBLT5u7uzm/VoF6nGvYl60/XFqLz/i4u58UZybIpJzDK7+bkFV2G3+bP3tNCtzjNMPXDocvSmP7rW7dnEQqYZY+6IUSioQrQ0Ry+I+pnNpTXg5dw== '"$USERNAME">>"$(su "$USERNAME" -c 'echo "$HOME"/.ssh/authorized_keys')"

## firewall-cmd rich-rule
    firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="888.888.888.888/32" port port="25565" protocol="tcp" accept"
    firewall-cmd --reload
    firewall-cmd --list-rich-rule
    firewall-cmd --list-all
    firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="888.888.888.888/32" port port="25565" protocol="tcp" accept"

## nmap-ncat
    # nc -l <ListenPort>
    nc -l 55500
    # nc -p <SourcePort> <RemoteHost> <RemotePort>
    nc -p 55500 888.888.888.888 443

## awscli
    python <(curl -LRs "https://bootstrap.pypa.io/get-pip.py")
    pip install -U awscli


# EOF
