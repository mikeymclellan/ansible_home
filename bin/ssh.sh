REGION=eu-west-2

OPENVPNIP=`aws cloudformation describe-stacks \
  --stack-name openvpn-personal \
  --profile mclellan \
  --region $REGION \
  --output text \
    | grep OpenVPNEIP \
    | sed s/^.*EIP// \
    | tr -d '[:blank:]'`

ssh -i /Users/mikey/.aws/mclellan-key-pair-mikey-$REGION.pem ec2-user@$OPENVPNIP
