#!/bin/bash
user_id=$(id -u)
log_folder="/var/log/shell-folder/"
log_file="/var/log/shell-folder/$0.log"
R="/e[31m" 
G="/e[32m"
Y="/e[33m"
B="/e[34m" 
N="/e[0m"
SCRIPT_DIR=$PWD

if [ $user_id -ne 0 ];then
echo -e "$R Please enter with root access$N"
exit 1
fi

validate(){
    if [ $1 -ne 0 ];then
    echo -e "$R $2  failed$N"
    else
    echo  -e "$G $2 success $N
    fi
    }


dnf module disable redis -y &>>$log_file
validate $? "disabling redis"

dnf module enable redis:7 -y $>>$log_file
validate $? "enabling redis"

dnf install redis -y $>>$log_file
validate $? "installing redis"

cp $SCRIPT_DIR/redis.conf /etc/redis/redis.conf $>>$log_file
validate $? "copying redis conf"

sed -i /s/127.0.0.1/0.0.0.0/g /etc/redis/redis.conf $>>$log_file
validate $? "allowing all connections"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf $>>$log_file
validate $? "allowing all connections"

systemctl enable redis $>>$log_file
validate $? "enabling redis"

systemctl start redis $>>$log_file
validate $? "starting redis"