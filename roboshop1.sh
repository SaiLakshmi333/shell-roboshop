#!/bin/bash
SG_ID="sg-0b4c1bffcd0783883"
AMI_ID="ami-0220d79f3f480ecf5"
for INSTANCE in $@
do
    instance_id=$(
         aws ec2 run-instances \
    --image-id ami-0220d79f3f480ecf5 \
    --instance-type t3.micro \
    --security-group-ids sg-0b4c1bffcd0783883 \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=roboshop}]' \
    --query 'Instances[0].InstanceId' \
    --output text)

    if [ $INSTANCE == frontend ];then
    IP = $(
        aws ec2 describe-instances \
         --instance-ids i-0db0fee230048fc82 \
         --query 'Reservations[*].Instances[*].PublicIpAddress' \
         --output text 
         )
         else
         IP = $(
        aws ec2 describe-instances \
         --instance-ids i-0db0fee230048fc82 \
         --query 'Reservations[*].Instances[*].PriviateIpAddress' \
         --output text 
         )
         fi
         done