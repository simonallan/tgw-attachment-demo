#!/bin/bash
# Associate new VPN attachemnt to all-route TG route table

echo 'AWS: Create a Transit Gateway VPN association'
echo 'please enter a VPC name (eg dev/test/prod; 1-16 chars; lower-case only)'
read -p 'VpcName: ' vpcname

echo 'please enter a Class B network octet (must be in the range [0-255])'
read -p 'Class B: ' classb

echo Thanks! Creating VPC now...

aws cloudformation create-stack \
--region 'eu-west-3' \
--stack-name tgw-vpn-association \
--template-body file://../templates/tgw-vpn-association.yml \
--parameters \
ParameterKey=VPNTransitGatewayAttachment,ParameterValue='' \
ParameterKey=VPNTGRoutingTable,ParameterValue=''