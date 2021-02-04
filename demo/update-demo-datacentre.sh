#!/bin/bash
# Updates 'datacenter' CF stack including a VPC with a publically-available IP address

aws cloudformation update-stack \
--region 'eu-west-3' \
--stack-name datacentre-vpc \
--template-body file://../vpnlink/tgw-demo-datacentre.yml
