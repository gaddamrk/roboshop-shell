script_location=$(pwd)
log=/tmp/roboshop.log

echo -e "\e[35m install nginx \e[0m"
yum install nginx -y &>>${log}
echo $?
echo -e "\e[35m remove old content\e[0m"
rm -rf /usr/share/nginx/html/*  &>>${log}
echo -e "\e[35m download the frontend content\e[0m"
curl -o /tmp/frontend.zip http://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}

cd /usr/share/nginx/html
echo -e "\e[35m extract the frontend file\e[0ms"
unzip /tmp/frontend.zip &>>${log}
echo -e "\e[35m copy the roboshop content file\e[0m"
cp $script_location/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
echo -e "\e[35m efnable nginx\e[0m"
systemctl enable nginx &>>${log}
echo -e "\e[35m start nginx\e[0m"
systemctl restart nginx &>>${log}



