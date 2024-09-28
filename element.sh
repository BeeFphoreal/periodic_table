#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
 
# if no user input 
if [[ -z $1 ]]
 then
  echo "Please provide an element as an argument."
  exit 0
fi

INPUT=$1

ATOMIC_NUMBER=""

 # get atomic_number if input is number
if [[ "$INPUT" =~ ^[0-9]+$ ]]; 
  then
   ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $INPUT;")
 #get atomic_number if input is symbol
elif [[ "$INPUT" =~ ^[A-Za-z]{1,2}$ ]]
 then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$INPUT';")
 #get atomic_number if input is name
  else ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements where name = '$INPUT';")
fi

# if user input doesnt exist 
 if [[ -z $ATOMIC_NUMBER ]]
  then 
   echo "I could not find that element in the database."
  exit 0
  fi

# select name
 NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
# select symbol
SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER;")
# select type from types referencing type_id
TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
# select type 
TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id = properties.type_id WHERE properties.atomic_number = $ATOMIC_NUMBER;")
# select mass
MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")
# select melting point
MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;") 
# #select boiling point 
BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER;")


# output 
 echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

exit 0