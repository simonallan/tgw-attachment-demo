#!/bin/bash
# Launches 'datacenter' CF stack including a VPC with a publically-available IP address

aws cloudformation create-stack \
--region 'eu-west-3' \
--stack-name datacentre-vpc \
--template-body file://../vpnlink/tgw-demo-datacentre.yml

