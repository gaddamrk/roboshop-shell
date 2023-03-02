source common.sh

print_head "copy mongo repo files"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log}
status_check

print_head "install mongodb"
yum install mongodb-org -y &>>${log}
status_check

print_head "enable mongodb"
systemctl enable mongod &>>${log}
status_check

print_head "start mongod"
systemctl start mongod &>>${log}
status_check

print_head "update mongod listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log}
status_check

print_head "restart mongod"
systemctl restart mongod &>>${log}
status_check