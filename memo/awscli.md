#### workdir
    v_aws_dir="$(date +'AWS_%Y%m%d_%H%M%S')"
    mkdir ${HOME:?}/${v_aws_dir:?} && cd ${v_aws_dir:?}
    ls -ld ${HOME:?}/AWS_*

#### VPC作成
    aws ec2 create-vpc --region ap-northeast-1 --cidr-block 10.0.0.0/16 >>"${v_aws_dir:?}/vpc.json"
    jq . ${v_aws_dir:?}/vpc.json 








###### EOF
