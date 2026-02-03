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

id roboshop &>> $log_file
if [$? -ne 0 ];then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $log_file
else
echo "user already exist" &>> $log_file
fi

mkdir -p /app
validate $? "creating app directory" &>> $log_file

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip 
validate $? "downloading shipping content" &>> $log_file

cd /app 
validate $? "go inside app directory " &>> $log_file

rm -rf /app/*
validate $? "removing old content" &>> $log_file

unzip /tmp/shipping.zip
validate $? "unzip the content" &>> $log_file

cd /app 
mvn clean package 
mv target/shipping-1.0.jar shipping.jar 
validate $? "clean" &>> $log_file

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service
validate $? "copying the service" &>> $log_file

systemctl daemon-reload
validate $? "cdaemon reloaded" &>> $log_file

systemctl enable shipping 
systemctl start shipping
validate $? "enable and starting shipping " &>> $log_file

dnf install mysql -y 
validate $? "installing mysql client" &>> $log_file

mysql -h $mysql_host -uroot -pRoboShop@1 < /app/db/schema.sql
validate $? "Load Schema, Schema in database is the structure to it like what tables to be created and their necessary application layouts" &>> $log_file

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/app-user.sql 
validate $? "Create app user, MySQL expects a password authentication"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/db/master-data.sql
validate $? "load master data"

systemctl restart shipping
validate $? "restart shipping"




