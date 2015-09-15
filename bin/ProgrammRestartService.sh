#!/bin/sh

source $CURRENT_DIR/NodeExecutorService.sh

message "Process runner initialized"


FindConfigFile() {
    message "Searching config file in $BASE_PATH"
    CONFIG_FILE="$(find $BASE_PATH ! -regex ".*[/]\.git[/]?.*" -name config.sh)"

	if [ -z $CONFIG_FILE ]; then
		message "Config file not found!"
		return 1
	fi
	
    message Founded config file: $CONFIG_FILE
	message Read config file $(cat $CONFIG_FILE)
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
	
	message "Restarting application"
	
	if [ $APP_TYPE="node"]; then
		RunNodeApplication
	fi
	
}
