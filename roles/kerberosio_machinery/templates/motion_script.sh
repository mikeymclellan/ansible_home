#!/bin/bash

INTERVAL=240
LAST_TIME_FILE="/tmp/last_command_execution_time.txt"

# Get the current time.
TIME="$(date +%s)"


function ping {
        name=$(echo $JSON | python -c "import sys, json; print json.load(sys.stdin)['instanceName']")
        /usr/bin/wget https://maker.ifttt.com/trigger/camera/with/key/ujWeUdCpj6tIw6ZAlGBpF?value1=$name -O /dev/null &

        echo $TIME > $LAST_TIME_FILE
}

# Check if the last execution time file exists. If it does not exist, run the command. If it does exist, check the time stored in it against the current time.
if [ -e ${LAST_TIME_FILE} ]; then
    LAST_TIME="$(cat "${LAST_TIME_FILE}")"
    DELTA_TIME=$(($TIME-$LAST_TIME))

    # If the time since the last execution is greater than the time interval between command executions, execute the command and save the current time to the last execution time file.
    if [ ${DELTA_TIME} -ge ${INTERVAL} ]; then
        ping
    fi
else
    ping
fi