source common.sh

print_head "copy mongo repo files"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo
status_check

print_head "install mongodb"
yum install mongodb-org -y
status_check

print_head "enable mongodb"
systemctl enable mongod
status_check

print_head "start mongod "
systemctl start mongod
status_check

print_head "update mongod listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
status_check

print_head "restart mongod"
systemctl restart mongod
status_check