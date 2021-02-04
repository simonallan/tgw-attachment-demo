#!/bin/bash
# Attaches VPCs to TransitGateway

echo 'Attach VPCs to the TransitGateway by associating Subnet IDs'
echo .
echo '** Double check you have updated the TransitGateway ID in Params **'
echo .
echo 'please enter a VPC name (eg dev/test/prod; 1-16 chars; lower-case only)'
read -p 'VpcName: ' vpcname

echo 'please enter the VPC ID'
read -p 'VPC ID: ' vpcid

echo 'please enter the target VPC public subnet IDs in a single comma-delimited list'
echo 'eg "subnet-09441e43ca9514418,subnet-0ad5473442b18d6b3" '
read -p 'Subnet IDs: ' subnetids

echo 'Thanks! Attaching $vpcname subnets to the TGW now...'

aws cloudformation create-stack \
--region 'eu-west-3' \
--stack-name $vpcname-vpc-attach \
--template-body file://../templates/tgw-vpc-attachment.yml \
--parameters \
ParameterKey=VpcId,ParameterValue=$vpcid \
ParameterKey=SubnetIds,ParameterValue=$subnetids \
ParameterKey=TransitGatewayId,ParameterValue='tgw-0929d88202b39ca82'
