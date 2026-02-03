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

____________________
#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

dnf module disable redis -y &>>$LOGS_FILE
dnf module enable redis:7 -y &>>$LOGS_FILE
VALIDATE $? "Enable Redis:7"

dnf install redis -y  &>>$LOGS_FILE
VALIDATE $? "Installed Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Allowing remote connections"

systemctl enable redis &>>$LOGS_FILE
systemctl start redis 
VALIDATE $? "Enabled and started Redis"

____________________
#!/bin/bash
user_id=$(id -u)
log_folder="/var/log/shell_folder/"
log_file="$log_folder/$0.log"
R="\e[31m"
G="\e[32m" 
Y="\e[33m"
B="\e[34m" 
N="\e[0m"
SCRIPT_DIR=$PWD
mongodb_host_id="mongodb.devopswithsai.online"
redis_host_id="redis.devopswithsai.online"

if [ $user_id -ne 0 ];then
echo -e "$R Please enter with root access $N"
exit 1
fi

mkdir -p $log_folder
validate(){
    if [ $1 -ne 0 ];then
    echo -e "$2 is $R failed $N"
    else
    echo -e "$2 is $G success $N"
    fi
}

dnf module disable nodejs -y  &>>$log_file
dnf module enable nodejs:20 -y &>>$log_file
validate $? "disabling and enabling nodejs"

dnf install nodejs -y &>>$log_file
validate $? "installing nodejs"


id roboshop
if [ $? -ne 0 ];then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
validate $? "user added"
else
echo "user already exist"
fi

mkdir /app &>>$log_file
validate $? "app directory created"

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip &>>$log_file
validate $? "downloaded the user content"


cd /app &>>$log_file
validate $? "Go to app directory"

rm -rf */app/ &>>$log_file
validate $? "removed existing data"

unzip /tmp/user.zip &>>$log_file
validate $? "unzipped the content to access"

cd /app &>>$log_file
npm install &>>$log_file
validate $? "npm dependencies installed"

cp $SCRIPT_DIR/user.service /etc/systemd/system/user.service &>>$log_file
validate $? "copied user service"

systemctl daemon-reload &>>$log_file
validate $? "daemon-reloaded"

systemctl enable user &>>$log_file
systemctl start user &>>$log_file
validate $? "ebable and disable"


____________________
#!/bin/bash
user_id=$(id -u)
log_folder="/var/log/shell-script/"
log_file="$log_folder/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
SCRIPT_DIR=$PWD
redis_host_name="redis.devopswithsai.online"

if [ $user_id -ne 0 ];then
echo -e "$R please enter with root access $N" &>>$log_file
exit 1

mkdir -p $log_folder
 validate(){
    if [ $1 -ne 0 ];then
    echo -e "$2 $R failed $N"
    else
    echo -e "$2 $R success $N"
    fi 
 }

dnf module disable nodejs -y &>>$log_file
dnf module enable nodejs:20 -y &>>$log_file
validate $? "disabled and enabled"

dnf install nodejs -y &>>$log_file
validate $? "installed nodejs"

id roboshop
if [ $? -ne 0 ];then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
validate $? "user added"
else
echo "user already exist"
fi

mkdir -p /app &>>$log_file
validate $? "creating app directory"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip &>>$log_file
validate $? "downloaded the cart content"

cd /app &>>$log_file

rm -rf */app/ &>>$log_file
validate $? "removed the old content"

unzip /tmp/cart.zip &>>$log_file
validate $? "unzipped the cart content"

cd /app &>>$log_file
npm install &>>$log_file
validate $? "unzipped the cart content"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service &>>$log_file
validate $? "copied the cart service"

systemctl daemon-reload &>>$log_file
validate $? "deamon-reloaded"

systemctl enable cart &>>$log_file
systemctl start cart &>>$log_file
validate $? "enable and disable"











    
