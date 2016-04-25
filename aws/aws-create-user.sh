#!/bin/bash
if [[ -z $1 ]]; then
  echo "Usage: bash aws-create-user.sh <username> <aws-profile>"
  exit 0
fi

if [[ -z $2 ]]; then
  echo "Usage: bash aws-create-user.sh <username>"
  exit 0
fi  
aws iam create-user --user-name $1 --profile $2
CREDENTIALS=$(aws iam create-access-key --user-name $1 --profile $2 --query 'AccessKey.[AccessKeyId,SecretAccessKey]' --output text)

echo "The credentials for user $1 are:"
echo "AccessKey e SecretKey: ${CREDENTIALS}"

echo "[INFO] - Save these data securely."
