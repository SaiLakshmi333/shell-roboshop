#!/bin/bash
user_id=$(id -u)
log_folder="/var/log/shell-folder/"
log_file="/var/log/shell-folder/$0.log"
R="\e[31m" 
G="\e[32m"
Y="\e[33m"
B="\e[34m" 
N="\e[0m"
SCRIPT_DIR=$PWD

if [ $user_id -ne 0 ];then
echo -e "$R Please enter with root access$N"
exit 1
fi

mkdir -p $log_folder

validate(){
    if [ $1 -ne 0 ];then
    echo -e "$R $2  failed$N"
    else
    echo  -e "$G $2 success $N"
    fi
}

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
validate $? "copying repo"

dnf install rabbitmq-server -y
validate $? "installing rabbitmq servr"

systemctl enable rabbitmq-server
systemctl start rabbitmq-server
validate $? "enable and start rabbitmq servr"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
