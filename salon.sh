#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

MAIN_MENU () {

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "1) cut\n2) dry\n3) color"
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in

1) echo -e "\nWhat's your phone number?";;
2) echo -e "\nWhat's your phone number?";;
3) echo -e "\nWhat's your phone number?";;
*) MAIN_MENU "I could not find that service. What would you like today?" ;;
esac

read CUSTOMER_PHONE

#Detect existing customer
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

#if new customer

if [[ -z $CUSTOMER_ID ]]
then
  echo -e "\nWhat's your name?"
  read CUSTOMER_NAME
  CUSTOMER_NAME_ENTERED=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nWhat time would you like your $($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED"), $CUSTOMER_NAME?"
  read SERVICE_TIME
  APPOINTMENT_SCHEDULED=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  echo -e "\nI have put you down for a $($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED") at $SERVICE_TIME, $CUSTOMER_NAME."
else

  OLD_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
  echo -e "\nWhat time would you like your $($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED"), $OLD_CUSTOMER_NAME?"
  read SERVICE_TIME
  APPOINTMENT_SCHEDULED=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  echo -e "\nI have put you down for a $($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED") at $SERVICE_TIME, $OLD_CUSTOMER_NAME."

fi

exit

}

MAIN_MENU