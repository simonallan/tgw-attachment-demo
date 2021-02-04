#!/bin/bash
# Creates a stack for a basic VPC with two subnets and an Internet Gateway

echo 'AWS: Create a basic VPC with Cloudformation'
echo 'please enter a VPC name (eg dev/test/prod; 1-16 chars; lower-case only)'
read -p 'VpcName: ' vpcname

echo 'please enter a Class B network octet (must be in the range [0-255])'
read -p 'Class B: ' classb

echo Thanks! Creating VPC now...

aws cloudformation create-stack \
--region 'eu-west-3' \
--stack-name $vpcname-vpc \
--template-body file://../vpnlink/tgw-demo-vpc.yml \
--parameters \
ParameterKey=ClassB,ParameterValue=$classb \
ParameterKey=VpcName,ParameterValue=$vpcname

