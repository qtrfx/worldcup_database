#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TRUNCATE=$($PSQL "TRUNCATE games, teams CASCADE")
RESTART1=$($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART")
RESTART2=$($PSQL "ALTER SEQUENCE games_game_id_seq RESTART")
echo "Database has been reset."

cat "./games.csv" | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  
  if [[ -z $WINNER_ID ]]
  then
    WINNER_ADDED=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $WINNER_ADDED == "INSERT 0 1" ]]
    then
      echo "Added the team of $WINNER to the database."
      fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      OPPONENT_ADDED=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $OPPONENT_ADDED == "INSERT 0 1" ]]
      then
        echo Added the team $OPPONENT to the database.
        fi
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    fi
    ENTRY_ADDED=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
    echo "Added the $ROUND game that took place in $YEAR between $WINNER and $OPPONENT where $WINNER beat $OPPONENT $WINNER_GOALS:$OPPONENT_GOALS."
  fi
    


done