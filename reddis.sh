source common.sh

print_head "set up reddis epo files"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>>${log}
status_check

print_head "enable reddis 6.2 dnf module"
dnf module enable redis:remi-6.2 -y &>>${log}
status_check

print_head "install reddis"
yum install redis -y  &>>${log}
status_check

print_head "update reddis listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>>${log}
status_check

print_head "enable redis"
systemctl enable redis &>>${log}
status_check

print_head "start redis"
systemctl start redis &>>${log}
status_check