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
