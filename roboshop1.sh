#!/bin/bash

SG_ID="sg-0b4c1bffcd0783883"
AMI_ID="ami-0220d79f3f480ecf5"
ZONE_ID="Z067791029EEJ0FAK30QG"
DOMAIN_NAME="devopswithsai.online"

for instance in "$@"
do
  instance_id=$(
    aws ec2 run-instances \
      --image-id "$AMI_ID" \
      --instance-type t3.micro \
      --security-group-ids "$SG_ID" \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
      --query 'Instances[0].InstanceId' \
      --output text
  )

  echo "Launched instance: $instance_id"

  sleep 10

  if [ "$instance" = "robo" ]; then
    IP=$(aws ec2 describe-instances \
      --instance-ids "$instance_id" \
      --query 'Reservations[].Instances[].PublicIpAddress' \
      --output text)

    RECORD_NAME="$DOMAIN_NAME"
  else
    IP=$(aws ec2 describe-instances \
      --instance-ids "$instance_id" \
      --query 'Reservations[].Instances[].PrivateIpAddress' \
      --output text)

    RECORD_NAME="$instance.$DOMAIN_NAME"
  fi

  echo "IP address: $IP"
  echo "Creating record: $RECORD_NAME"

  aws route53 change-resource-record-sets \
    --hosted-zone-id "$ZONE_ID" \
    --change-batch "{
      \"Comment\": \"Update A record\",
      \"Changes\": [
        {
          \"Action\": \"UPSERT\",
          \"ResourceRecordSet\": {
            \"Name\": \"$RECORD_NAME\",
            \"Type\": \"A\",
            \"TTL\": 1,
            \"ResourceRecords\": [
              { \"Value\": \"$IP\" }
            ]
          }
        }
      ]
    }"

  echo "Record updated for $instance"
done
