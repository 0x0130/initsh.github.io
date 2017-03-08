# Azure CLI

## Prepare

    # 特権ユーザに昇格
    sudo su -
    
    # 依存関係をインストール
    yum install -y gcc libffi-devel python-devel openssl-devel
    
    # 【参考】jqをインストール
    curl -LR https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/bin/jq; chmod 755 /usr/bin/jq
    
    # 【参考】Azure CLI 2.0 (az) azコマンド実行ユーザを作成
    USER_NAME=az
    GROUP_NAME=az
    GROUP_ID=12600
    USER_ID=12600
    groupadd -g ${GROUP_ID:?} ${GROUP_NAME:?}
    useradd -u ${USER_ID:?} -g ${GROUP_ID:?} ${USER_NAME:?}
    su - ${USER_NAME:?}


## Setup Azure CLI ([参考](https://docs.microsoft.com/en-us/cli/azure/get-started-with-azure-cli))

    # Azure CLI 2.0 (az) をインストール
    curl -L https://aka.ms/InstallAzureCli | bash
    
    # シェルを再実行し、環境変数などを反映させる
    exec -l ${SHELL:?}
    
    # azureへログイン (出力をファイル"az.login.json"として保存)
    # 実行後に表示されるURLにアクセスし、コードを入力の後、ログイン情報を入力
    az login | tee ./az.login.json
    
    # アカウント情報を表示
    az account show
    
    # 【参考】
    az vm image list --all >az.vm.image.list.all.json &
    jobs
    disown
    jobs
    
## Setup ResourceGroup
    
    # 
    RG_NAME=DevResourceGroup
    RG_LOCATION=japaneast
    
    # 
    az group create -l ${RG_LOCATION:?} -n ${RG_NAME:?}
    
## Setup VirtualNetwork
    
    # 
    VNET_NAME=DevVirtualNetwork
    VNET_CIDR=192.168.0.0/16
    SEQ=001
    SUBNET_NAME=DevSubnet${SEQ}
    SUBNET_CIDR=192.168.$(seq ${SEQ}).0/24
    
    # 
    az network vnet create --resource-group ${RG_NAME:?} -l ${RG_LOCATION:?} -n ${VNET_NAME:?} --address-prefix ${VNET_CIDR:?}
    
    # 
    az network vnet subnet create -g ${RG_NAME:?} -l ${RG_LOCATION:?} --vnet-name ${VNET_NAME:?} -n ${SUBNET_NAME:?} --address-prefix ${SUBNET_CIDR:?}

    
    
    
    
    
    
    
    
## Setup VirtualMachine ([_](https://docs.microsoft.com/ja-jp/azure/virtual-machines/virtual-machines-linux-create-cli-complete))
    
    # 
    SEQ=001
    VM_NAME=DevVM${SEQ:?}
    VM_IMAGE=OpenLogic:CentOS:6.8:6.8.20170105
    VM_ADMIN_USER_NAME=azure-user
    VM_OS_TYPE=linux
    
    # 
    az vm create -n ${VM_NAME:?} -g ${RG_NAME:?} --image ${VM_IMAGE:?} --admin-username ${VM_ADMIN_USER_NAME:?}
    
    
    
    
    
    
    
    
    
## Regions
|Azure CLI 2.0 Regions|和名|
|:--|:--|
|centralus||
|eastasia||
|southeastasia||
|eastus||
|eastus2||
|westus||
|westus2||
|northcentralus||
|southcentralus||
|westcentralus||
|northeurope||
|westeurope||
|japaneast|東日本|
|japanwest|西日本|
|brazilsouth||
|australiasoutheast||
|australiaeast||
|westindia||
|southindia||
|centralindia||
|canadacentral||
|canadaeast||
|uksouth||
|ukwest||
|koreacentral||
|koreasouth||


###### EOF
