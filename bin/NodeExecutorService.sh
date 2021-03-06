#!/bin/bash
#
# Service script for a Node.js application running under Forever.
#
# This is suitable for Fedora, Red Hat, CentOS and similar distributions.
# It will not work on Ubuntu or other Debian-style distributions!
#
# There is some perhaps unnecessary complexity going on in the relationship between
# Forever and the server process. See: https://github.com/indexzero/forever
#
# 1) Forever starts its own watchdog process, and keeps its own configuration data
# in /var/run/forever.
#
# 2) If the process dies, Forever will restart it: if it fails but continues to run,
# it won't be restarted.
#
# 3) If the process is stopped via this script, the pidfile is left in place; this
# helps when issues happen with failed stop attempts.
#
# 4) Which means the check for running/not running is complex, and involves parsing
# of the Forever list output.
#
# chkconfig: 345 80 20
# description: my application description
# processname: my_application_name
# pidfile: /var/run/my_application_name.pid
# logfile: /var/log/my_application_name.log
#

# Source function library.
. /etc/init.d/functions


InitNodeApplicationRunner() {
        NAME=$APP_NAME

        SOURCE_DIR=$BASE_PATH/$SRC_DIR
        SOURCE_FILE=$SRC_FILE

        user=$USER
        pidfile=$SOURCE_DIR/forever/$NAME.pid
        #todo parametrize log
        logfile=$SOURCE_DIR/forever/$NAME.log
        forever_dir=$SOURCE_DIR/forever

        node=node
        forever=/usr/local/lib/node_modules/forever/bin/forever
        sed=sed

        echo ------------------------------------
        echo Configured:
        echo APP_NAME=$NAME
        echo USER=$USER
        echo SOURCE_DIR=$SOURCE_DIR
        echo SOURCE_FILE=$SOURCE_FILE
        echo PIDFILE=$pidfile
        echo LOGFILE=$logfile
        echo ------------------------------------
		
		
	if [ -f $pidfile ]; then
		read pid < $pidfile
	else
		pid=""
	fi

	if [ "$pid" != "" ]; then
	  # Gnarly sed usage to obtain the foreverid.
	  sed1="/$pid]/p"
	  sed2="s/.*[([0-9]+)].*s$pid.*/1/g"
	  foreverid=`$forever list -p $forever_dir | $sed -n $sed1 | $sed $sed2`
	else
	  foreverid=""
	fi
}

StopNodeApplication() {
  echo -n "Shutting down $NAME node instance : "
  if [ "$foreverid" != "" ]; then
    $node $SOURCE_DIR/prepareForStop.js
    $forever stop -p $forever_dir $id
  else
    echo "Instance is not running";
  fi
  RETVAL=$?
}

StartNodeApplication() {
  echo "Starting $NAME node instance: "

  if [ "$foreverid" == "" ]; then
    # Create the log and pid files, making sure that
    # the target use has access to them
    touch $logfile
    chown $user $logfile

    touch $pidfile
    chown $user $pidfile

    # Launch the application
    daemon --user=root \
     $forever start -p $forever_dir --pidFile $pidfile -l $logfile \
      -a -d $SOURCE_DIR/$SOURCE_FILE

    RETVAL=$?
  else
    echo "Instance already running"
    StopNodeApplication
  fi
}