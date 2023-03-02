source common.sh

echo -e "\e[35m install nginx \e[0m"
yum install nginx -y &>>${log}
status_check

echo -e "\e[35m remove old content\e[0m"
rm -rf /usr/share/nginx/html/*  &>>${log}
status_check

echo -e "\e[35m download the frontend content\e[0m"
curl -o /tmp/frontend.zip http://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
status_check

cd /usr/share/nginx/html
echo -e "\e[35m extract the frontend files\e[0ms"
unzip /tmp/frontend.zip &>>${log}
status_check

echo -e "\e[35m copy the roboshop content file\e[0m"
cp $script_location/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
status_check

echo -e "\e[35m efnable nginx service \e[0m"
systemctl enable nginx &>>${log}
status_check

echo -e "\e[35m start nginx service\e[0m"
systemctl restart nginx &>>${log}
status_check


