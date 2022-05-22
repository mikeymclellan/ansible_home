#!/bin/sh

STACK_NAME=openvpn-personal
# London eu-west-2
# Singapore ap-southeast-1
REGION=eu-west-2

aws cloudformation deploy \
    --template-file roles/openvpn_router/templates/cfn-openvpn.yaml \
    --stack-name $STACK_NAME \
    --profile mclellan \
    --region $REGION \
    --parameter-overrides SSHKeyName=mikey \
    --capabilities CAPABILITY_IAM

/bin/echo -n "OVPN Config file: "
aws cloudformation --profile mclellan --region $REGION describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs[2].OutputValue"

