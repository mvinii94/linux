#!/bin/bash
#USAGE: bash remove-sg-rules.sh sg-uyei123 ambev 
SGid=$1
CLIENT=$2
REMOVE=$(aws ec2 describe-security-groups --group-ids ${SGid} --profile ${CLIENT} --output json | jq -c '.SecurityGroups[] | .IpPermissions[] | {IpProtocol,FromPort,ToPort,IpRanges}')
for line in $(echo ${REMOVE}); do aws ec2 revoke-security-group-ingress --group-id ${SGid} --profile ${CLIENT} --ip-permissions ${line}; done
