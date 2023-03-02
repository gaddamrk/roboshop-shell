script_location=$(pwd)
log=/tmp/roboshop.log


# setup nodeJS repos. Vendor is providing a script to setup the repos.

echo -e "\e[35m configuring node js files \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
exit
fi
echo -e "\e[35m install nodejs \e[0m"
yum install nodejs -y &>>${log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
exit
fi
echo -e "\e[35m add application user \e[0m"
useradd roboshop &>>${log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
  echo refer log file more information log - ${log}
exit
fi
mkdir -p /app &>>{log}

echo -e "\e[35m download the catalogue content \e[0m"
curl -l -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
exit
fi
echo -e "\e[35m clean up the old  content \e[0m"
rm -rf /app/* &>>${log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m extracting the app content  \e[0m"
cd /app
unzip /tmp/catalogue.zip &>>{log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
exit
fi
echo -e "\e[35m install the nodejs dependency \e[0m"
cd /app
npm install &>>{log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
exit
fi
echo -e "\e[35m configuring catalogue servcie files \e[0m"
cp $script_location/files/catalogue.service /etc/systemd/system/catalogue.service &>>{log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m reload systemd \e[0m"
systemctl daemon-reload &>>{log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
exit
fi
echo -e "\e[35m enable catalogue service \e[0m"
systemctl enable catalogue &>>{log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
exit
fi
echo -e  "\e[35m start catalogue service \e[0m"
systemctl start catalogue &>>{log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
exit
fi
echo -e "\e[35m configuring the monogo repo \e[0m"
cp $script_location/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
exit
fi
echo -e "\e[35m install mongodb client \e[0m"
yum install mongodb-org-shell -y &>>${log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
exit
fi
echo -e "\e[35m load schema \e[0m"
mongo --host mongodb-dev.devops70roboshop.online </app/schema/catalogue.js &>>${log}
if [ $? -eq 0 ]
then
  echo success
else
  echo failure
exit
fi
