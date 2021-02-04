# Add VPN link to existing shared VPCs

The purpose of this document is describe the process necessary to add a VPN link to the existing Shared VPC/Transit Gateway infrastucture. Find detailed configuration instructions in our [sharePoint](https://cancerresearchuko365.sharepoint.com/sites/AWSUpgrade/Shared%20Documents/Forms/AllItems.aspx?viewid=535d5125%2Dc202%2D45eb%2D8d2b%2D61269adfb014&id=%2Fsites%2FAWSUpgrade%2FShared%20Documents%2FProcesses%20and%20Procedures%2FNetwork) site.

## Intended Audience

This document's intended audience is the SysAdmins in charge of the updates of the Landing Zone AWS solution.

## Tasks

* Create Customer Gateway.
* Add VPN attachment to the existing Transit Gateway.
* Associate the newly created VPN attachment to the existing Transit Gateway routing table tagged as `All-Route-Table`.
* Add propagation of the VPN attachememnt and route to each existing environment Transit Gateway Route table: `Dev-Route-Table`,  `Test-Route-Table`,  `Prod-Route-Table`
* Make sure VPC subnets have a route to reach the entire CDIR VPN network. Currently, there is a route to reach 10.0.0.0/8. If that is not the CDIR block used then add a new route so traffic comming from the VPC can reach the TG.

## Procedure

* Create a CloudFormation stack using `templates/cgw.yaml` template and run it. This will create a Customer Gateway.
* Create VPN attachment stack using `templates/tgw-vpn-attachment.yaml` template.
* Create a ClouFormation stack using `templates/tg-vpn-association.yml`, this will associate newly created VPN attachment to `All-Route-Table` and propagagte the route.
* Propagete VPN attachment and add static route to ENV Transit Gateway routing tables by running `templates/tg-vpn-route-association-propagation.yaml` for each ENVIRONMENT.s
* Download [VPN configuration data](https://eu-west-2.console.aws.amazon.com/vpc/home?region=eu-west-2#VpnConnections), select Checkpoint version of the document.The Networking team needs this to configure the VPN endpoint.
* When the VPN side is configured go to the AWS Site-to-site console, the [tunnel](https://eu-west-2.console.aws.amazon.com/vpc/home?region=eu-west-2#VpnConnections) information tab should show tunnels are up.
* Test the connection.

## Monitoring

At this stage Monitoring of the VPN Site-to-site connection is implemented as a [CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html) alarm.
The template used to deploy this resource to the Network account is available under the [core-network/templates](../templates/vpn-alarms.yaml) folder.

Currently the endpoint for the SNS topic the alarm send events is email. We need to investigate if
send http request to a Dynatrace endpoint will make possible integrate this cloudWatch alarm in Dynatrace dashboard.

The site-to-site connection has two tunnels, the metric being evaluated is tunnelState from
AWS VPN Connection Metrics group

**tunnelState metric**:

* 0 if tunnel is down, 1 if tunnel is up.
* Two tunnels being compound in this metric.

**Alarm configuration:**

* 1 Data Point.
* 1 Evaluation periods of 5 minutes.
* Action: send event to SNS topic.
* SNS subscription: email.
* Action OK: SNS topic
* Action ALARM: SNS topic
* Threshold: 0
* Comparasion operator: LessThanOrEqualToThreshold

Therefore, if the sum of both tunnels metric is `less than or equal to Zero` for 5 minutes the alarm goes into to ALARM state.
Similarly, if the sum goes from Zero to any value greater than Zero goes from `ALARM` to `OK` state.

**TunnelDataIn metric**:

* This alarm monitors amount of traffic coming in the VPN connection. Again the amount of traffic is the sum of both tunnels.
* We do not know what amount of traffic we will having in this connection, I took 5M in 15 minutes as threshol but this will need to be reviewed once we have applications using this connection.

**Alarm configuration:**

* 1 Data Point.
* 1 Evaluation periods of 15 minutes.
* Action: send event to SNS topic.
* SNS subscription: email.
* Action OK: SNS topic
* Action ALARM: SNS topic
* Threshold: 1000000 bytes
* Comparasion operator: LessThanOrEqualToThreshold

Therefore, if the sum of both tunnels metric is `less than or equal to 1000000` for 15 minutes the alarm goes into to ALARM state.

**TunnelDataOut metric**:

* This alarm monitors amount of traffic coming in the VPN connection. Again the amount of traffic is the sum of both tunnels.
* We do not know what amount of traffic we will having in this connection, I take 1M in 15 minutes as threshold but this will need to be reviewed once we have applications using this connection.

**Alarm configuration:**

* 1 Data Point.
* 1 Evaluation periods of 15 minutes.
* Action: send event to SNS topic.
* SNS subscription: email.
* Action OK: SNS topic
* Action ALARM: SNS topic
* Threshold: 1000000 bytes
* Comparasion operator: LessThanOrEqualToThreshold

Therefore, if the sum of both tunnels metric is `less than or equal to 1000000` for 15 minutes the alarm goes into to ALARM state.

### How to deploy

* run/update [core-network/templates/vpn-alarms.yaml](../templates/vpn-alarms.yaml) in `cloudformation` passing vpnId as parameter

Parameter|Value|Explanation
---------|-----|-----------
VpnId|Refer to AWS network console|The ID of the VPC
SubscriptionEmail|manuel.barragan@cancer.org.uk|email to be notified
ThresholdDataIn|5000000 bytes| Data In threshold
ThresholdDataOut|100000 bytes|Data Out threshold
TopicDisplayName| LZtoDataCenter | SNS topic short name
TopicName | AWS-Landing-Zone-to-Datacenter-tunnel-alarm | SNS notification for the alarms

## Documentation

* [AWS CloudWatch](https://aws.amazon.com/cloudwatch/)
* Monitoring [VPN tunnels](https://docs.aws.amazon.com/vpn/latest/s2svpn/monitoring-cloudwatch-vpn.html) using CloudWatch
* AWS CloudFormation, [CloudWatch Alarm resource](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cw-alarm.html)
* AWS Site-to-Site VPN [User Guide](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwjWq93_gZ3qAhXQilwKHZ17D5kQFjADegQIARAB&url=https%3A%2F%2Fdocs.aws.amazon.com%2Fvpn%2Flatest%2Fs2svpn%2Fs2s-vpn-user-guide.pdf&usg=AOvVaw2SdNMnUvrPMAwzbS16oGgs)
