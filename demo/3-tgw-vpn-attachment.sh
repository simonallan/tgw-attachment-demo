#!/bin/bash
# Creates New Customer Gateway

aws cloudformation create-stack \
--region 'eu-west-3' \
--stack-name datacentre-vpn-attachment \
--template-body file://../templates/tgw-vpn-attachment.yaml \
--parameters \
ParameterKey=LandingZoneTransitGatewayId,ParameterValue='tgw-0929d88202b39ca82' \
ParameterKey=LandingZoneCustomerGatewayId,ParameterValue='cgw-04d5f237d7d909af3'

