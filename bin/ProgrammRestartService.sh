#!/bin/sh

source $CURRENT_DIR/NodeExecutorService.sh

echo "Process runner initialized"


FindConfigFile() {
    echo "Searching config file in $BASE_PATH"
    CONFIG_FILE="$(find $BASE_PATH ! -regex ".*[/]\.git[/]?.*" -name config.sh)"

    echo Founded config file: $CONFIG_FILE
	echo Read config file $(cat $CONFIG_FILE)
    source $CONFIG_FILE
		        
}

RunNodeApplication() {
	InitNodeApplicationRunner
	StartNodeApplication
}

RestartApplication() {
    echo "Restarting application"
	FindConfigFile
	
	if [ $APP_TYPE="node"]; then
		RunNodeApplication
	fi
	
}
