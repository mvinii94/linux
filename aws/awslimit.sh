#!/bin/bash
regions=$(aws ec2 describe-regions --output text --query 'Regions[*].RegionName')
attributes="max-instances max-elastic-ips vpc-max-elastic-ips"
for region in $regions; do
  echo; echo "region=$region"
  aws ec2 describe-account-attributes --region $region --attribute-names $attributes --output text --query 'AccountAttributes[*].[AttributeName,AttributeValues[0].AttributeValue]' |
    tr '\t' '=' | sort
done
