#!/bin/bash -e
#===============================================================================
#       FILE:  create-vpc.sh
#       USAGE:  bash create-vpc.sh <profile-name> <region>
#       DESCRIPTION: Create and Setup a AWS VPC from ZERO.
#       OPTIONS:  ---
#       REQUIREMENTS:  awscli, jq, perl
#       AUTHOR:  Marcus Vinicius - GIT: mvinii94 - marcus.vinicius@adtsys.com.br
#===============================================================================

#-------------------------------------------------------------------------------
# BEGINING SCRIPT
#-------------------------------------------------------------------------------
DATE=$(date +%d%b%Y-%Hh%Mm)
CLIENT=$1
AWS_REGION=$2
MYIP=$(curl -s ifconfig.me)

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
function LOG(){
 DATE=$(date +"%d%b%Y %H:%M:%S")
 echo -e "[${DATE}] - $1" | tee -a ${LOGFILE}
}

#-------------------------------------------------------------------------------
# Create VPC
#-------------------------------------------------------------------------------
VPCid=$(aws ec2 create-vpc --profile $CLIENT --region $AWS_REGION --cidr-block 10.100.0.0/16 --query 'Vpc.VpcId' --output text)
aws ec2 modify-vpc-attribute --profile $CLIENT --region $AWS_REGION --vpc-id $VPCid --enable-dns-support "{\"Value\":true}"
aws ec2 modify-vpc-attribute --profile $CLIENT --region $AWS_REGION --vpc-id $VPCid --enable-dns-hostnames "{\"Value\":true}"
aws ec2 create-tags --resources $VPCid --tags Key=Name,Value=VPC-$CLIENT Key=activation_date,Value=$(date +"%d%m%Y") --profile $CLIENT --region $AWS_REGION
LOG "VPC CRIADA: $VPCid"

#-------------------------------------------------------------------------------
# Create a Internet Gateway and attach it to our new VPC
#-------------------------------------------------------------------------------
IGWid=$(aws ec2 create-internet-gateway --profile $CLIENT --region $AWS_REGION --query 'InternetGateway.InternetGatewayId' --output text)
LOG "Internet Gateway criado: $IGWid"
aws ec2 attach-internet-gateway --profile $CLIENT --region $AWS_REGION --internet-gateway-id $IGWid --vpc-id $VPCid
LOG "Internet Gatway $IGWid associado a VPC: $VPCid"

#-------------------------------------------------------------------------------
# Create the subnets and associate them with the Routing Table
#-------------------------------------------------------------------------------
ip="10"
z="0"
RTid=$(aws ec2 describe-route-tables --profile $CLIENT --region $AWS_REGION --output text | grep $VPCid | awk '{print $2}')
for az in $(aws ec2 describe-availability-zones --profile $CLIENT --region $AWS_REGION --output text | awk '{print $4}')
do
 LOG "Criando SUBNET: $az"
 SUBNET=$(aws ec2 create-subnet --profile $CLIENT --region $AWS_REGION --vpc-id $VPCid --cidr-block 10.100.$ip.0/24 --availability-zone $az --output text --query 'Subnet.SubnetId')
 aws ec2 associate-route-table --profile $CLIENT --region $AWS_REGION --route-table-id $RTid --subnet-id $SUBNET
 LOG "SUBNET $SUBNET associada a Route Table: $RTid"
 ip=$[$ip+10]

done

#-------------------------------------------------------------------------------
# Create the default route in the Route Table
#-------------------------------------------------------------------------------

if ! aws ec2 create-route --profile $CLIENT --region $AWS_REGION --route-table-id $RTid --destination-cidr-block 0.0.0.0/0 --gateway-id $IGWid; then
 LOG "Erro ao criar rota de saida na Route Table: $RTid"
fi
LOG "ROUTE TABLE CONFIGURADA: $RTid"

#-------------------------------------------------------------------------------
# Configura Security Group
#-------------------------------------------------------------------------------

SGid=$(aws ec2 create-security-group --profile $CLIENT --region $AWS_REGION --group-name MySecurityGroup --description "SG-Default" --vpc-id $VPCid --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --profile $CLIENT --region $AWS_REGION --group-id $SGid --protocol tcp --port 22 --cidr $MYIP/32
aws ec2 authorize-security-group-ingress --profile $CLIENT --region $AWS_REGION --group-id $SGid --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --profile $CLIENT --region $AWS_REGION --group-id $SGid --protocol tcp --port 443 --cidr 0.0.0.0/0
LOG "Security Group: $SGid - criado e configurado"


echo "[DONE]"
