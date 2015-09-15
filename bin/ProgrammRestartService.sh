#!/bin/sh

source $CURRENT_DIR/NodeExecutorService.sh

echo "Process runner initialized"


FindConfigFile() {
    echo "Searching config file in $BASE_PATH"
    CONFIG_FILE="$(find $BASE_PATH ! -regex ".*[/]\.git[/]?.*" -name config.sh)"

	if [ -z $CONFIG_FILE ]; then
		echo "Config file not found!"
		return 1
	fi
	
    echo Founded config file: $CONFIG_FILE
	echo Read config file $(cat $CONFIG_FILE)
    source $CONFIG_FILE      

	return 0
}

RunNodeApplication() {
	InitNodeApplicationRunner
	StartNodeApplication
}

RestartApplication() {
    
	FindConfigFile
	functionResult=$?
	
	if [ $functionResult -eq 1 ]; then
		return 1
	fi
	
	echo "Restarting application"
	
	if [ $APP_TYPE="node"]; then
		RunNodeApplication
	fi
	
}
