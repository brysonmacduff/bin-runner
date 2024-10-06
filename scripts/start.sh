#!/bin/bash
echo "$(date) - [Binary Runner] - Starting"
mkdir /tmp/logs
cpp-template &>> /tmp/logs/cpp-template.txt &
element_manager 1000000 &>> /tmp/logs/element_manager.txt &
echo "$(date) - [Binary Runner] - Done"

# start.sh must not exit because all processes spawned from it will exit too, since it is PID 1
while [ $1 = "--persistent" ]
do 
    sleep 1 # sleep for 1 second
done