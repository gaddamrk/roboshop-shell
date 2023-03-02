source common.sh

print_head "configuring node js files"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
status_check

print_head " install nodejs "
yum install nodejs -y &>>${log}
status_check

print_head "add application user"
id roboshop &>>${log}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log}
status_check

print_head "download the catalogue content"
curl -l -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
status_check

print_head "clean up  old  content""
rm -rf /app/* &>>${log}
status_check

mkdir -p /app &>>{log}

print_head "install the nodejs dependency"
cd /app
npm install &>>{log}
status_check

print_head "configuring catalogue servcie files"
cp $script_location/files/catalogue.service /etc/systemd/system/catalogue.service &>>{log}
status_check

print_head "reload systemd"
systemctl daemon-reload &>>{log}
status_check

print_head "enable catalogue service"
systemctl enable catalogue &>>{log}
status_check

print_head "start catalogue service"
systemctl start catalogue &>>{log}
status_check

print_head "configuring the monogo repo"
cp $script_location/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
status_check

print_head "install mongodb client"
yum install mongodb-org-shell -y &>>${log}
status_check

print_head "load schema"
mongo --host mongodb-dev.devops70roboshop.online </app/schema/catalogue.js &>>${log}
status_check









