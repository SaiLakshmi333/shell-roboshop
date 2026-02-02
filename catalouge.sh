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

mkdir -p shell_folder
validate(){
    if [ $1 -ne 0 ];then
    echo "$R $2 is failed $N" | tee -a $log_file
    else
    echo "$G $2 is success $N" | tee -a $log_file
    fi
}

dnf module disable nodejs -y
validate $? "disable old nodejs" | tee -a $log_file

dnf module enable nodejs:20 -y
validate $? "enable nodejs" | tee -a $log_file

dnf install nodejs -y
validate $? "installing nodejs" | tee -a $log_file

id roboshop &>>$log_file
if [ $? -ne 0];then

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
validate $? "creating system user" | tee -a $log_file
else
echo -e "roboshop user already exist $Y skipping $n" | tee -a $log_file
fi

mkdir -p /app
validate $? "creating directory" | tee -a $log_file

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
validate $? "downloading catalouge code" | tee -a $log_file

cd /app 
validate $? "moving app directory" | tee -a $log_file

rm -rf /app*
validate $? "removing the existing code" | tee -a $log_file

unzip /tmp/catalogue.zip
validate $? "unzip catalouge code" | tee -a $log_file

npm install 
validate $? "installing dependencies" | tee -a $log_file

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
validate $? "copy catalogue service" | tee -a $log_file

systemctl daemon-reload
validate $? "daemon reloaded successfully" | tee -a $log_file

systemctl enable catalogue
validate $? "enabled catalogue" | tee -a $log_file

systemctl start catalogue
validate $? "started catalogue" | tee -a $log_file

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y
validate $? "install mongodb" | tee -a $log_file

mongosh --host $mongodb_host </app/db/master-data.js
validate $? "install mongodb" | tee -a $log_file






