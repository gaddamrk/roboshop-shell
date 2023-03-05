script_location=$(pwd)
log=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]
  then
    echo -e "\e[32m success \e[0m"
  else
    echo -e "\e[31m failure \e[0m"
    echo refer log file more information log - ${log}
  exit
  fi
}

print_head() {
  echo -e "\e[1m $1 \e[0m"
}

nodejs() {

  source common.sh

  print_head "configuring node js files"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
  status_check

  print_head "install nodejs"
  yum install nodejs -y &>>${log}
  status_check

  print_head "add application user"
  id roboshop &>>${log}
  if [ $? -ne 0 ]
    then
    useradd roboshop &>>${log}
  fi
  status_check


  print_head "download the ${component} content"
  curl -l -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  status_check

  print_head "clean up the old content"
  rm -rf /app/* &>>${log}
  status_check

  print_head "extracting the app content"
  cd /app
  unzip /tmp/${component}.zip &>>{log}
  status_check


  print_head "install the nodejs dependency"
  cd /app
  npm install &>>{log}
  status_check

  print_head "configuring ${component} servcie files"
  cp $script_location/files/${component}.service /etc/systemd/system/${component}.service &>>{log}
  status_check

  print_head "reload systemd"
  systemctl daemon-reload &>>{log}
  status_check

  print_head "enable ${component} service"
  systemctl enable ${component} &>>{log}
  status_check

  print_head "start ${component} service"
  systemctl start ${component} &>>{log}
  status_check

  print_head "configuring the monogo repo"
  cp $script_location/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
  status_check

  print_head "install mongodb client"
  yum install mongodb-org-shell -y &>>${log}
  status_check

  print_head "load schema"
  mongo --host mongodb-dev.devops70roboshop.online </app/schema/${component}.js &>>${log}
  status_check

}

