#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

#echo $($PSQL "TRUNCATE appointments, customers, services")


CHOOSE_SERVICE() {
  # get services
  SERVICES_OFFERED=$($PSQL "SELECT service_id, name FROM services")
  # display services
  echo "$SERVICES_OFFERED" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  echo -e "\nChoose a service"
  read SERVICE_ID_SELECTED

  # get choosen service
  SERVICE_NAME_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  # if service is not found
  if [[ -z $SERVICE_NAME_SELECTED ]]
  then
    CHOOSE_SERVICE
  else
    # get phone number from user
    echo -e "\nEnter Your Phone Number"
    read CUSTOMER_PHONE

    # get user name from database with phone number
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    # if not in database
    if [[ -z $CUSTOMER_NAME ]]
    then
      # get customer name
      echo -e "\nEnter Your Name"
      read CUSTOMER_NAME

      # add user to database
      ADD_USER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi

    # get service time
    echo -e "\nEnter Service Time"
    read SERVICE_TIME

    # get user id from database with phone number
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    # set appointment
    ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

    # success message
    echo "I have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."



  fi
}



# exit
EXIT() {
  echo -e "\nThank you for your patronage\n"
}

CHOOSE_SERVICE
