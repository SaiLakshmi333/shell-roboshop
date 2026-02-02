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

    aws route53 change-resource-record-sets /
    --hosted-zone-id Z067791029EEJ0FAK30QG /
    --change-batch file://change-record.json

    {
  "Comment": "Update A record for webserver",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "webserver.example.com.",
        "Type": "A",
        "TTL": 1,
        "ResourceRecords": [
          {
            "Value": "192.0.2.44"
          }
        ]
      }
    }
  ]
}

aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch "$(cat <<EOF
{ "Comment":"Update A record","Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"$RECORD_NAME","Type":"A","TTL":1,"ResourceRecords":[{"Value":"$IP"}]}}]}
EOF
)"

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

----------
#!/bin/bash
SG_ID="sg-0b4c1bffcd0783883"
AMI_ID="ami-0220d79f3f480ecf5"
ZONE_ID="Z067791029EEJ0FAK30QG"
DOMAIN_NAME="devopswithsai.online"
for instance in $@
do
    instance_id=$(
         aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type t3.micro \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text)

    if [ $instance == "robo" ]; then
    IP=$(
        aws ec2 describe-instances \
         --instance-ids $instance_id \
         --query 'Reservations[].Instances[].PublicIpAddress' \
         --output text 
         )
         RECORD_NAME="$DOMAIN_NAME"
         else
    IP=$(
        aws ec2 describe-instances \
         --instance-ids $instance_id \
         --query 'Reservations[].Instances[].PrivateIpAddress' \
         --output text 
         )
         RECO0RD_NAME="$instance.$DOMAIN_NAME"
         fi
echo "IP address :$IP"
        

aws route53 change-resource-record-sets \
--hosted-zone-id $ZONE_ID \
--change-batch '
{
    "Comment": "Update A record for webserver",
    "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "'$RECORD_NAME'",
        "Type": "A",
        "TTL": 1,
        "ResourceRecords": [
          {
            "Value": "'$IP'"
          }
        ]
    }
      
    ]
    }
    
  
                                     


echo "record updated : $instance"

done

____________________

for instance in $@
do
    INSTANCE_ID=$( aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type "t3.micro" \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text )

    if [ $instance == "frontend" ]; then
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PublicIpAddress' \
            --output text
        )
        RECORD_NAME="$DOMAIN_NAME" # daws88s.online
    else
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PrivateIpAddress' \
            --output text
        )
        RECORD_NAME="$instance.$DOMAIN_NAME" # mongodb.daws88s.online
    fi

    echo "IP Address: $IP"

    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Updating record",
        "Changes": [
            {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "'$RECORD_NAME'",
                "Type": "A",
                "TTL": 1,
                "ResourceRecords": [
                {
                    "Value": "'$IP'"
                }
                ]
            }
            }
        ]
    }
    '

    echo "record updated for $instance"

done
______________________

#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.daws88s.online

if [ $USERID -ne 0 ]; then
    echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

dnf module disable nodejs -y &>>$LOGS_FILE
VALIDATE $? "Disabling NodeJS Default version"

dnf module enable nodejs:20 -y &>>$LOGS_FILE
VALIDATE $? "Enabling NodeJS 20"

dnf install nodejs -y &>>$LOGS_FILE
VALIDATE $? "Install NodeJS"

id roboshop &>>$LOGS_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
    VALIDATE $? "Creating system user"
else
    echo -e "Roboshop user already exist ... $Y SKIPPING $N"
fi

mkdir -p /app 
VALIDATE $? "Creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip  &>>$LOGS_FILE
VALIDATE $? "Downloading catalogue code"

cd /app
VALIDATE $? "Moving to app directory"

rm -rf /app/*
VALIDATE $? "Removing existing code"

unzip /tmp/catalogue.zip &>>$LOGS_FILE
VALIDATE $? "Uzip catalogue code"

npm install  &>>$LOGS_FILE
VALIDATE $? "Installing dependencies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "Created systemctl service"

systemctl daemon-reload
systemctl enable catalogue  &>>$LOGS_FILE
systemctl start catalogue
VALIDATE $? "Starting and enabling catalogue"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>>$LOGS_FILE

INDEX=$(mongosh --host $MONGODB_HOST --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js
    VALIDATE $? "Loading products"
else
    echo -e "Products already loaded ... $Y SKIPPING $N"
fi

systemctl restart catalogue
VALIDATE $? "Restarting catalogue"

    
