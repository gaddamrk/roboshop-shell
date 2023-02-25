script_location=$(pwd)

echo -e "\e[35m install nginx \e[0m"
yum install nginx -y

echo -e "\e[35m remove old content\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[35m download the frontend content\e[0m"
curl -o /tmp/frontend.zip http://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html
echo -e "\e[35m extract the frontend file\e[0ms"
unzip /tmp/frontend.zip
echo -e "\e[35m copy the roboshop content file\e[0m"
cp $script_location/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[35m efnable nginx\e[0m"
systemctl enable nginx
echo -e "\e[35m start nginx\e[0m"
systemctl restart nginx
