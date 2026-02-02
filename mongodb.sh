#!/bin/bash
user_id=$(id -u)
log_folder="/var/log/shell_folder"
log_file="/var/log/shell_folder/$0.log"
R="\e[31m"
G="\e[32m"
y="\e[33m"
b="\e[34m" 
n="\e[0m"
if [ $user_id -ne 0 ];then
echo "Please access with root user"
exit 1
else
fi
mkdir -p $log_folder
validate(){
    if [ $? -ne 0 ];then
    echo -e "$R $2 is failed $n" &>>$log_file
    exit 1
    else 
    echo -e "$R $2 is success $n" &>>$log_file
    fi
}

cp mongodb.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-org -y 
validate $? "installing mongodb" &>>$log_file

systemctl enable mongod
validate $? "enabling mongodb" &>>$log_file

systemctl start mongod 
validate $? "starting mongodb" &>>$log_file

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "allowing remote connections" &>>$log_file

systemctl restart mongod
validate $? "restarting mongodb" &>>$log_file

