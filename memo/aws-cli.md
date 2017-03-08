# AWS CLI

## Prepare
    # 特権ユーザに昇格
    sudo su -
    
    # pipをインストール
    curl -LRs "https://bootstrap.pypa.io/get-pip.py" | python
    
    # 【参考】jqをインストール
    curl -LR https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/bin/jq; chmod 755 /usr/bin/jq


## Setup AWS CLI
    pip install awscli
    aws configure


## Setup VPC ([参考](http://www.simpline.co.jp/tech/?p=267))

    # 変数を設定
    VPC_NAME=dev-vpc
    VPC_CIDR=10.0.0.0/16
    VPC_REGION=ap-northeast-1
    
    # vpcのnameタグと同名のディレクトリを`$HOME`配下に作成 && 移動
    cd $HOME ; mkdir ${VPC_NAME} ; cd ${VPC_NAME} ; pwd
    
    # VPCを作成
    VPC_CREATE_JSON="$(aws ec2 create-vpc --region ${VPC_REGION} --cidr-block ${VPC_CIDR} | tee /dev/stderr)"
    
    # VPCのid情報を、変数に格納
    VPC_ID="$(echo "${VPC_CREATE_JSON}" | sed -r -e /VpcId/\!d -e 's/.*"[^"]+": "([^"]+)".*/\1/g' | tee /dev/stderr)"
    
    # VPCにNameタグを設定
    aws ec2 create-tags --resources ${VPC_ID} --tags Key=Name,Value=${VPC_NAME}
    
    # VPCの情報をファイルに保存
    aws ec2 describe-vpcs --vpc-id ${VPC_ID} | tee ${VPC_NAME}.json
    
    # 【参考】VPC作成時の情報をファイルに保存
    echo "${VPC_CREATE_JSON}" | tee ${VPC_NAME}.json.create
    
    # VPCの設定を変更(VPC内の名前解決をサポート)
    aws ec2 modify-vpc-attribute --vpc-id ${VPC_ID} --enable-dns-support
    
    # 設定確認
    aws ec2 describe-vpc-attribute --vpc-id ${VPC_ID} --attribute enableDnsSupport
    
    # VPCの設定を変更(VPC内のGIPを持つ仮想マシンにPublicDNS名を付与)
    aws ec2 modify-vpc-attribute --vpc-id ${VPC_ID} --enable-dns-hostnames
    
    # 設定確認
    aws ec2 describe-vpc-attribute --vpc-id ${VPC_ID} --attribute enableDnsHostnames


## Setup IGW ([参考](http://www.simpline.co.jp/tech/?p=267))

    # IGW用変数を設定
    IGW_NAME=dev-igw
    
    # IGWを作成
    IGW_CREATE_JSON="$(aws ec2 create-internet-gateway | tee /dev/stderr)"
    
    # IGWのid情報を、変数に格納
    IGW_ID="$(echo "${IGW_CREATE_JSON}" | sed -r -e /InternetGatewayId/\!d -e 's/.*"[^"]+": "([^"]+)".*/\1/g' | tee /dev/stderr)"
    
    # VPCにIGWをアタッチ
    aws ec2 attach-internet-gateway --internet-gateway-id ${IGW_ID} --vpc-id ${VPC_ID}
    
    # IGWにNameタグを設定
    aws ec2 create-tags --resources ${IGW_ID} --tags Key=Name,Value=${IGW_NAME}
    
    # IGWの情報をファイルに保存
    aws ec2 describe-internet-gateways --filters "Name=internet-gateway-id,Values=${IGW_ID}" | tee ${IGW_NAME}.json
    
    # 【参考】IGW作成時の情報をファイルに保存
    echo "${IGW_CREATE_JSON}" | tee ${IGW_NAME}.json.create


## Setup SUBNET ([参考](http://www.simpline.co.jp/tech/?p=267))

    # SUBNET用変数を設定
    SEQ=001
    SUBNET_NAME=dev-subnet-${SEQ}
    SUBNET_CIDR=10.0.$(seq ${SEQ}).0/24
    SUBNET_AZ=${VPC_REGION}a
    #SUBNET_AZ=${VPC_REGION}c
    
    # 確認
    echo -e "${SUBNET_NAME}\n${SUBNET_CIDR}\n${SUBNET_AZ}"
    
    # SUBNETを作成
    SUBNET_CREATE_JSON="$(aws ec2 create-subnet --vpc-id ${VPC_ID} --cidr-block ${SUBNET_CIDR} --availability-zone ${SUBNET_AZ} | tee /dev/stderr)"
    
    # SUBNETのid情報を、変数に格納
    SUBNET_ID="$(echo "${SUBNET_CREATE_JSON}" | sed -r -e /SubnetId/\!d -e 's/.*"[^"]+": "([^"]+)".*/\1/g' | tee /dev/stderr)"
    
    # Auto Assign Public IPを設定
    aws ec2 modify-subnet-attribute --subnet-id ${SUBNET_ID} --map-public-ip-on-launch
    
    # SUBNETにNameタグを設定
    aws ec2 create-tags --resources ${SUBNET_ID} --tags Key=Name,Value=${SUBNET_NAME}
    
    # SUBNETの情報をファイルに保存
    aws ec2 describe-subnets --subnet-ids ${SUBNET_ID} | tee ${SUBNET_NAME}.json
    
    # 【参考】SUBNET作成時の情報をファイルに保存
    echo "${SUBNET_CREATE_JSON}" | tee ${SUBNET_NAME}.json.create












###### EOF
