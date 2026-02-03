#!/bin/bash
user_id=$(id -u)
log_folder="/var/log/shell_folder/"
log_file="/var/log/shell_folder/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
SCRIPT_DIR=$PWD
mysql_host=mysql.devopswithsai.online
if [ $user_id -ne 0 ];then
echo -e "$R Please enter with root access $N" | tee -a $log_file
exit 1
fi

mkdir -p $log_folder 
validate(){
    if [ $1 -ne 0 ];then
    echo -e "$R $2 is failed $N" &>> $log_file
    exit 1
    else
    echo -e "$G $2 is success $N" &>> $log_file
    fi
}

dnf install maven -y
validate $? "installing maven" &>> $log_file

id roboshop &>>$log_file
if [ $? -ne 0 ];then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $log_file
validate $? "creating system user"
else
echo "user already exist" &>> $log_file
fi

mkdir -p /app &>> $log_file
validate $? "creating app directory" 

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip  &>> $log_file
validate $? "downloading shipping content" 

cd /app &>> $log_file
validate $? "go inside app directory " 

rm -rf /app/* &>> $log_file
validate $? "removing old content" 

unzip /tmp/shipping.zip &>> $log_file
validate $? "unzip the content" 

cd /app &>> $log_file
mvn clean package &>> $log_file
mv target/shipping-1.0.jar shipping.jar &>> $log_file
validate $? "clean" 

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service &>> $log_file
validate $? "copying the service" 

systemctl daemon-reload &>> $log_file
validate $? "cdaemon reloaded" 

systemctl enable shipping &>> $log_file
systemctl start shipping &>> $log_file
validate $? "enable and starting shipping " 

dnf install mysql -y &>> $log_file
validate $? "installing mysql client" 

mysql -h $mysql_host -uroot -pRoboShop@1 -e 'use cities'

if [ $? -ne 0 ];then
mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/schema.sql &>> $log_file
validate $? "Load Schema, Schema in database is the structure to it like"

mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $log_file
validate $? "Create app user, MySQL expects a password authentication"

mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/master-data.sql &>> $log_file
validate $? "load master data"

else
echo -e "data is already loaded"
fi

systemctl enable shipping &>> $log_file
validate $? "enable shipping"

systemctl start shipping &>> $log_file
validate $? "start shipping"




