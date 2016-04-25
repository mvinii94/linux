#!/bin/bash
REGION='us-east-1'
 
#Get the AMIs id from the file file-with-list-of-ami-ids.txt
for AMI_ID in $(cat file-with-list-of-ami-ids.txt); do
  SNAP_ID=''
  #Get the snapshot that belongs to the AMI
  my_array=( $(aws ec2 describe-images --image-ids $AMI_ID --region $REGION --output text --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId') )
  #Get the number of result in array
  my_array_length=${#my_array[@]}
 
  #Deregister the AMI
  echo 'Deregistering AMI: '$AMI_ID
  aws ec2 deregister-image --image-id $AMI_ID --region $REGION
  echo 'Deleting snapshots from $AMI_ID'
 
  #Delete the snapshots
  for (( i=0; i<$my_array_length; i++ )); do
    SNAP_ID=${my_array[$i]}
    echo 'Deleting Snapshot: ' $SNAP_ID
    aws ec2 delete-snapshot --snapshot-id $SNAP_ID --region $REGION
  done
done
