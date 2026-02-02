#!/bin/bash
user_id=$(id -u)
log_folder="/var/log/shell_folder"
log_file="/var/log/shell_folder/$0/log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
SCRIPT_DIR=$PWD
mongodb_host=mongodb.devopswithsai.online
if [ $user_id -ne 0 ];then
echo -e "$R Please enter with root access $N" | tee -a $log_file
exit 1
fi

mkdir -p $log_folder 
validate(){
    if [ $1 -ne 0 ];then
    echo "$R $2 is failed $N" &>>$log_file
    else
    echo "$G $2 is success $N" &>>$log_file
    fi
}

dnf module disable nodejs -y &>>$log_file
validate $? "disable old nodejs" 

dnf module enable nodejs:20 -y &>>$log_file
validate $? "enable nodejs" 

dnf install nodejs -y &>>$log_file
validate $? "installing nodejs" 

id roboshop &>>$log_file
if [ $? -ne 0];then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$log_file
validate $? "creating system user" 
else
echo -e "roboshop user already exist $Y skipping $n" &>>$log_file 
fi

mkdir -p /app &>>$log_file
validate $? "creating directory" 

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip  &>>$log_file
validate $? "downloading catalouge code" 
cd /app &>>$log_file
validate $? "moving app directory" 

rm -rf /app/* &>>$log_file
validate $? "removing the existing code" 

unzip /tmp/catalogue.zip &>>$log_file
validate $? "unzip catalouge code" 

npm install &>>$log_file
validate $? "installing dependencies" 

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service &>>$log_file
validate $? "copy catalogue service" 

systemctl daemon-reload &>>$log_file
validate $? "daemon reloaded successfully" 

systemctl enable catalogue &>>$log_file
validate $? "enabled catalogue" 

systemctl start catalogue &>>$log_file
validate $? "started catalogue" 

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
dnf install mongodb-mongosh -y &>>$log_file
validate $? "install mongodb" 

INDEX=$(mongosh --host $mongodb_host --quiet  --eval 'db.getMongo().getDBNames().indexOf("catalogue")') 

if [ $INDEX -le 0 ]; then

    mongosh --host $MONGODB_HOST </app/db/master-data.js

    VALIDATE $? "Loading products"

else

    echo -e "Products already loaded ... $Y SKIPPING $N"

fi

systemctl restart catalogue
VALIDATE $? "Restarting catalogue"







