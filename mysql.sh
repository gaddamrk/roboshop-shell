source common.sh


if [ -z "${root_mysql-password}" ]; then
  echo "variable root mysql password missing"
  exit
fi

print_head " diable mysql default module"
dnf module disable mysql -y  &>>${log}
status_check

print_head "copy mysql repo files"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log}
status_check


print_head "install mysqld server"
yum install mysql-community-server -y &>>${log}
status_check


print_head "enable mysqld"
systemctl enable mysqld &>>${log}
status_check

print_head "start mysqld"
systemctl start mysqld &>>${log}
status_check

print_head "reset default database password"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${log}
status_check


