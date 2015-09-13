#!/bin/sh

GIT_URL=$1
BASE_PATH=$2

LOCAL_DIR=$(pwd)

echo Changing directory to $BASE_PATH
cd $BASE_PATH

echo Cloninng repo $GIT_URL
git clone $1

#source $LOCAL_DIR/GitService.sh
COMMAND="$LOCAL_DIR/GitServise.sh $1 $2 2> $LOCAL_DIR/log_executor.log"
SCHEDULE="*/1 * * * * root"

echo "$SCHEDULE" $COMMAND

echo "$SCHEDULE" $COMMAND > /etc/cron.d/GitServiceSchedule.cron
