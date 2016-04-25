#!/bin/bash
id=$1 example AMI id
type=$2 # or "instance" or "volume" or "snapshot" or ...

regions=$(aws ec2 describe-regions --output text --query 'Regions[*].RegionName')
for region in $regions; do
    (
     aws ec2 describe-${type}s --region $region --$type-ids $id &>/dev/null &&
         echo "$id is in $region"
    ) &
done 2>/dev/null; wait 2>/dev/null
