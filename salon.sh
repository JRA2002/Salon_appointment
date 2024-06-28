#!/bin/bash
#script to make an appointment into salon
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"
echo -e "\n--Welcome to choco's SALON--\n"
OTHER_MENU() {

  if [[ -z $SERVICE_ID_SELECTED || $SERVICE_ID_SELECTED>4 ]]
  then
    echo "please enter a correct value :"
    MAIN_MENU 
  fi
}
HAIRCUT() {
  echo -e "\nPlease enter your phone"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    
    echo -e "\nYou dont have an appointment...."
    echo -e "\nPlease enter your name :"
    read CUSTOMER_NAME
    echo -e "\nPlease enter your time service :"
    read SERVICE_TIME

    echo "$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")"
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo "$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME')")"
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  else 
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
    echo "hello $CUSTOMER_NAME below you find your appointments :"
    SERVICE_NAME=$($PSQL "SELECT services.name FROM services INNER JOIN appointments USING(service_id) INNER JOIN customers USING(customer_id) WHERE customer_id=$CUSTOMER_ID;")
    TIME=$($PSQL "SELECT time FROM services INNER JOIN appointments USING(service_id) INNER JOIN customers USING(customer_id) WHERE customer_id=$CUSTOMER_ID;")
    echo -e "\n$CUSTOMER_NAME you have an $SERVICE_NAME at the $TIME ."
    echo -e "\nHave a great day !!"

    
  fi
}
EXIT() {
  echo -e "\nThan you for use our site"
}
MAIN_MENU() {
  echo -e "1) haircut\n2) colorfull\n3) hairstyle"
  echo -e "\nEnter a service ID :"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1)HAIRCUT ;;
    2)HAIRCUT ;;
    3)HAIRCUT ;;
    4)EXIT;;
    *)OTHER_MENU ;;
  esac
}
MAIN_MENU
