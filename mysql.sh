#!/bin/bash
user_id=$(id -u)
log_folder="/var/log/shell_folder"
log_file="$log_folder/$0.log"
R="\e[31m"
G="\e[32m" 
Y="\e[33m" 
B="\e[34m" 
N="\e[0m"
SCRIPT_DIR=$PWD

if [ $user_id -ne 0 ];then
echo "please access wth root user"
exit 1
fi
mkdir -p $log_folder 
validate(){
    if [ $1 -ne 0 ];then
    echo -e "$2 is $R failed"
    else
    echo -e "$2 is $G success"
    fi
}

dnf install mysql-server -y
validate $? "installing mysql"

systemctl enable mysqld
systemctl start mysqld  
validate $? "ebable and start mysql"

mysql_secure_installation --set-root-pass RoboShop@1 #get the password from user
validate $? "setup root password"

