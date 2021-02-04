#!/bin/bash
# Creates New Customer Gateway

aws cloudformation create-stack \
--region 'eu-west-3' \
--stack-name tgwdemo-cgw \
--template-body file://../templates/cgw.yaml \
--parameters \
ParameterKey=OnPremiseIPAddress,ParameterValue='15.237.6.61'

