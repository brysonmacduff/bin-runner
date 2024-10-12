#!/bin/bash

# constants
DATE_FORMAT="%Y-%m-%d"
TIME_FORMAT="%T"

# script arguments
PERSISTENT=$1

log()
{
    message=$1
    echo $(date +$DATE_FORMAT) $(date +$TIME_FORMAT) "[LOG]:" "$message"
}

# run a single binary
start_process()
{   
    # execute the binary with arguments appended to the command and logging directed to a log file
    bin_name=$1
    bin_args=$2
    bin_log_file="/tmp/logs/${bin_name}.txt"

    $bin_name $bin_args &>> $bin_log_file &

    log "Started ${bin_name} with arguments (${bin_args}). Logs are directed to ${bin_log_file}"
}

# run all binaries from bin.conf
start_processes()
{
    # iterate through binary names from the configuration file and start each process
    while read line
    do 
        # for each line, make an array where each indice is a word on the line

        line_items=()
        read -ra line_items <<< "$line"

        bin_name=${line_items[@]:0:1}
        bin_args=${line_items[@]:1}
        
        start_process "$bin_name" "$bin_args"

    done < bin.conf
}

# Report process statuses (active or inactive) and restart processes from bin.conf that have died
monitor_processes()
{
    while read line
    do 
        # for each line, make an array where each indice is a word on the line

        line_items=()
        read -ra line_items <<< "$line"

        # get the binary name from bin.conf and check if there is a process of it running 

        bin_name=${line_items[@]:0:1}
        search_result=$(ps -e | grep "$bin_name")

        bin_name=${line_items[@]:0:1}
        
        if [ -z "$search_result" ]; then

            bin_args=${line_items[@]:1}
    
            log "${bin_name} status is INACTIVE"
            log "Restarting ${bin_name}"
            start_process "$bin_name" "$bin_args"
        else
            log "${bin_name} status is ACTIVE"
        fi
     
    done < bin.conf
}

run_task_schedule() 
{
    monitor_processes
}

start_task_loop()
{
    # start all processes listed in bin.conf
    start_processes

    # start.sh must not exit because all processes spawned from it will exit too, since it is PID 1
    while [[ $1 = "--persistent" ]]
    do 
        run_task_schedule
        sleep 1 # sleep for 1 second
    done
}

# the script holds here
start_task_loop $PERSISTENT
