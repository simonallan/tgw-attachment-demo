
echo 'Attach VPC attachments to the TransitGateway route table'
echo 'please enter a VPC name (eg dev/test/prod; 1-16 chars; lower-case only)'
read -p 'VpcName: ' vpcname

echo 'please enter the VPC TGW attachment ID to associate with the TGW route table'
read -p 'VPC TGW attachment ID: ' tgwattachid

echo 'please enter the VPCs corresponding TGW route table ID'
read -p 'VPC Route Table ID: ' vpcroute

echo 'Thanks! Creating $vpcname VPC attachments now...'

aws cloudformation create-stack \
--region 'eu-west-3' \
--stack-name $vpcname-tgw-assoc \
--template-body file://../templates/tgw-vpc-association.yml \
--parameters \
ParameterKey=TransitGatewayAttachmentId,ParameterValue=$tgwattachid \
ParameterKey=TransitGatewayRouteTableId,ParameterValue=$vpcroute
