#!/bin/bash
IFS=$' \t\n'

# constants
DATE_FORMAT="%Y-%m-%d"
TIME_FORMAT="%T"

# script arguments
BIN_CONFIG_FILE=$1
PERSISTENT=$2

# redirect the orchestrator process logs to a file
exec &>> "/tmp/logs/orchestrator.txt"

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
    log "start_processes() -> Starting processes"
    # iterate through binary names from the configuration file and start each process
    while read line
    do 
        # for each line, make an array where each indice is a word on the line

        line_items=()
        read -ra line_items <<< "$line"

        bin_name=${line_items[@]:0:1}
        bin_args=${line_items[@]:1}
        
        start_process "$bin_name" "$bin_args"

    done < $BIN_CONFIG_FILE
}

# Report process statuses (active or inactive) and restart processes from bin.conf that have died
monitor_processes()
{
    log "monitor_process() -> Monitoring"
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
     
    done < $BIN_CONFIG_FILE
}

run_task_schedule() 
{
    log "run_task_schedule() -> Running tasks"
    monitor_processes
}

main()
{
    # start all processes listed in bin.conf
    start_processes

    # start.sh must not exit because all processes spawned from it will exit too, since it is PID 1
    while [[ $PERSISTENT = "--persistent" ]]
    do 
        run_task_schedule
        sleep 1 # sleep for 1 second
    done
}

# the script starts and holds here
main
