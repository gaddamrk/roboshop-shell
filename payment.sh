source common.sh

component=payment
schema_load=false

if [ -z "${roboshop_rabbitmq_password}" ]
  echo "variable of roboshop_rabbitmq_password is needed"
  exit
fi


PYTHON