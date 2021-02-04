#!/bin/bash
# Launches Transit Gateway CF stack

aws cloudformation create-stack \
--region 'eu-west-3' \
--stack-name transitgateway-demo \
--template-body file://../vpnlink/tgw.json
