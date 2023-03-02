source common.sh

print_head "install nginx"
yum install nginx -y &>>${log}
status_check

print_head "remove old content"
rm -rf /usr/share/nginx/html/*  &>>${log}
status_check

print_head "download the frontend content"
curl -o /tmp/frontend.zip http://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
status_check

cd /usr/share/nginx/html
print_head "extract the frontend files"
unzip /tmp/frontend.zip &>>${log}
status_check

print_head "copy the roboshop content file"
cp $script_location/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
status_check

print_head "enable nginx service"
systemctl enable nginx &>>${log}
status_check

print_head "start nginx service"
systemctl restart nginx &>>${log}
status_check


