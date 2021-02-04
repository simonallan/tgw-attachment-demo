#!/bin/bash
# Creates New Customer Gateway

echo 'Create and propogate VPC TGW route table associations'

echo 'please enter a VPC name (eg dev/test/prod; 1-16 chars; lower-case only)'
read -p 'VpcName: ' vpcname

echo 'please enter the VPN TransitGateway attachment ID'
read -p 'TransitGateway attachment ID: ' vpcattach

echo 'please enter the target VPC routing table ID'
read -p 'VPC TransitGateway route table: ' tgrtable

echo 'Thanks! Creating $vpcname route association now...'

aws cloudformation create-stack \
--region 'eu-west-3' \
--stack-name $vpcname-route-assoc \
--template-body file://../templates/tgw-env-route-association-propagation.yml \
--parameters \
ParameterKey=VPNTransitGatewayAttachment,ParameterValue=$vpcattach \
ParameterKey=VPNCDIRRange,ParameterValue='10.0.0.0/8' \
ParameterKey=EnvTGRTable,ParameterValue=$tgrtable
