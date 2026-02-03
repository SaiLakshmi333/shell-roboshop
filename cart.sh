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
    echo "$2 $R failed $N"
    else
    echo "$2 $R success $N"
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