#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $WINNER != 'winner' && $OPPONENT != 'opponent' ]]
  then
    # get WINNER_ID AND OPPONENT_ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    
    # if WINNER not found
    if [[ -z $WINNER_ID && -z $OPPONENT_ID ]]
    then
      # insert team
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

    elif [[ -z $WINNER_ID && -n $OPPONENT_ID ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    
    elif [[ -z $OPPONENT_ID && -n $WINNER_ID ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi

  fi
    # get new team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

  if [[ $YEAR != 'year' && $ROUND != 'round' && $WINNER != 'winner' && $OPPONENT != 'opponent' && $WIN_GOALS != 'winner_goals' && $OPP_GOALS != 'opponent_goals' ]]
  then
    # get game_id
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year = $YEAR AND round = '$ROUND' AND winner_id = $WINNER_ID AND opponent_id = $OPPONENT_ID AND winner_goals = $WIN_GOALS AND opponent_goals = $OPP_GOALS")
    
    # if not found
    if [[ -z $GAME_ID ]]
    then
      # insert new game
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WIN_GOALS, $OPP_GOALS)")
    fi

    #get new game_id
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year = $YEAR AND round = '$ROUND' AND winner_id = $WINNER_ID AND opponent_id = $OPPONENT_ID AND winner_goals = $WIN_GOALS AND opponent_goals = $OPP_GOALS")
    
  fi

done
