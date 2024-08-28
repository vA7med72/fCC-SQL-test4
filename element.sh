#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument." 
else
if [[ $1 =~ ^[0-9]+$ ]] 
then 
EL_NUM=$($PSQL "select atomic_number from elements where atomic_number = $1")
else
EL_NAME=$($PSQL "select name from elements where name='$1'")
EL_SYMBOL=$($PSQL "select symbol from elements where symbol='$1'")
fi
if [[ $EL_NAME ]]
then 
EL_NUM=$($PSQL "select atomic_number from elements where name='$EL_NAME'")
EL_SYMBOL=$($PSQL "select symbol from elements where name='$EL_NAME'")
elif [[ $EL_NUM ]]
then 
EL_NAME=$($PSQL "select name from elements where atomic_number=$EL_NUM")
EL_SYMBOL=$($PSQL "select symbol from elements where atomic_number=$EL_NUM")
elif [[ $EL_SYMBOL ]]
then 
EL_NAME=$($PSQL "select name from elements where symbol='$EL_SYMBOL'")
EL_NUM=$($PSQL "select atomic_number from elements where symbol='$EL_SYMBOL'")
else 
echo "I could not find that element in the database."
fi
if [[ $EL_NUM ]]
then
EL_MASS=$($PSQL "select atomic_mass from properties where atomic_number=$EL_NUM")
EL_MELT=$($PSQL "select melting_point_celsius from properties where atomic_number=$EL_NUM")
EL_BOIL=$($PSQL "select boiling_point_celsius from properties where atomic_number=$EL_NUM")
EL_TYPE=$($PSQL "select type from properties full join types using(type_id) where atomic_number=$EL_NUM")
echo "The element with atomic number $EL_NUM is $EL_NAME ($EL_SYMBOL). It's a $EL_TYPE, with a mass of $EL_MASS amu. $EL_NAME has a melting point of $EL_MELT celsius and a boiling point of $EL_BOIL celsius."

fi
fi