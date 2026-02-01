#!/bin/bash
SG_ID="sgr-0ab932e808b2d3392"
AMI_ID="ami-0220d79f3f480ecf5"

for instance in $@
do
aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type t3.micro \
    --security-group-ids $SG_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE}]' \
    --query 'Instances[].{InstanceId:InstanceId,PublicIp:PublicIpAddress}' \
    --output text
done

aws ec2 run-instances \
    --image-id ami-0220d79f3f480ecf5 \
    --instance-type t3.micro \
    --security-group-ids sg-0b4c1bffcd0783883 \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=roboshop}]' \

    aws ec2 describe-instances --instance-ids i-0db0fee230048fc82 --query 'Reservations[*].Instances[*].PublicIpAddress' --output text  -->pubilc ip/private ip
    get the instance id
    aws ec2 describe-instances --instance-ids i-0db0fee230048fc82 --query 'Reservations[*].Instances[*].PublicIpAddress' --output text  -->pubilc ip/private ip
aws ec2 run-instances \
    --image-id ami-0220d79f3f480ecf5 \
    --instance-type t3.micro \
    --security-group-ids sg-0b4c1bffcd0783883 \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=roboshop}]' \
    --query 'Instances[0].{InstanceId:InstanceId,PublicIp:PublicIpAddress}' \
    --output text

    aws ec2 run-instances \
    --image-id ami-0220d79f3f480ecf5 \
    --instance-type t3.micro \
    --security-group-ids sg-0b4c1bffcd0783883 \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=roboshop}]' \
    --query 'Instances[0].InstanceId' \
    --output text


    
