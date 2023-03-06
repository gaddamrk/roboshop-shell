source common.sh
if [ -z "${roboshop_rabbitmq_password}" ]
  echo "variable of roboshop_rabbitmq_password is needed"
  exit
fi

print_head "configuring  the erlang yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${log}
staus_check

print_head "configuring the rabbitmq yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${log}
status_check

print_head "install erlang and rebbitmq-server"
yum install erlang rabbitmq-server -y &>>${log}
staus_check

print_head "Enable rebbitmq-server"
ystemctl enable rabbitmq-server &>>${log}
staus_check

print_head " Start rabbitmq-server"
systemctl start rabbitmq-server &>>${log}
staus_check

print_head "Add application user"
rabbitmyctl list_users | grep roboshop &>>{log}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>>${log}
fi
staus_check

print_head "add tag to application user"
rabbitmqctl set_user_tags roboshop administrator &>>${log}
staus_check

print_head "Add permissions to application user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log}
status_check