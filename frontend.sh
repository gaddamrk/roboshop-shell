sript_location=$(pwd)


yum install nginx -y

systemctl enable nginx
systemctl restart nginx

rm -rf /usr/share/nginx/html/*

curl -o /tmp/frontend.zip http://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html
unzip /tmp/frontend.zip

cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
systemctl restart nginx
