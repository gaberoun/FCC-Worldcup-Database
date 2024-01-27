#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # negate header
  if [[ $YEAR != "year" && $ROUND != "Round" && $WINNER != "Winner" && $OPPONENT != "Opponent" && $WINNER_GOALS != "winner_goals" && $OPPONENT_GOALS != "opponent_goals" ]]
  then
    # insert values to teams

    # get unique winners
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if winner not found
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER == "INSERT 0 1" ]]
      then
        echo Inserted $WINNER to teams
      fi
      # get new team_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    fi

    # get unique opponents
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if opponent not found
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
      then
        echo Inserted $OPPONENT to teams
      fi
      # get new team_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    fi

    #insert values to games

    INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
    VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo Inserted game
    fi
  fi
done