#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Argument received?
if [[ -z $1 ]]
then
  # Exit condition
  echo "Please provide an element as an argument."
else
  # What was passed
  ELEMENT_ENTRY=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number::text = '$1' OR symbol = '$1' OR name = '$1'")

  # Not a valid entry
  if [[ -z $ELEMENT_ENTRY ]]
  then
    echo "I could not find that element in the database."
  else
    # Split ELEMENT_ENTRY by column
    IFS='|' read NUMBER SYMBOL NAME <<< "$ELEMENT_ENTRY"

    # Get properties of element
    PROPERTY_INFO=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number = $NUMBER")

    # Split line
    IFS='|' read ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE_ID <<< "$PROPERTY_INFO"

    # type_id to type
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID" | sed 's/^ //')

    # Result message
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
fi
