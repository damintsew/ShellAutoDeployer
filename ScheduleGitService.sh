#!/bin/sh

GIT_URL=$1
BASE_PATH=$2
APPLICATION_NAME=$(basename $BASE_PATH)

LOCAL_DIR=$(pwd)

echo Changing directory to $BASE_PATH
cd $BASE_PATH

echo Cloninng repo $GIT_URL
git clone $1

COMMAND="$LOCAL_DIR/bin/$(APPLICATION_NAME).cron $1 $2 >> $LOCAL_DIR/log_executor.log 2>&1"
SCHEDULE="*/1 * * * * root"

echo "$SCHEDULE" $COMMAND

echo "$SCHEDULE" $COMMAND > /etc/cron.d/GitServiceSchedule.cron
