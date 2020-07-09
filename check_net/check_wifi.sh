#!/bin/bash

# check all wifi devices status, keep one connected

LOG_FILE="/var/log/check_wifi.log"
SAVE_DAYS=7
CMD_LIST="nmcli date"

check_cmd()
{
    for item in ${CMD_LIST}
    do
        which ${item} > /dev/null 2>&1
        if [ $? -ne 0 ];
        then
            exit 1
        fi
    done
}

del_log()
{ 
    if [ -f ${LOG_FILE} ];
    then
        old_date=$(date -d "${SAVE_DAYS} days ago" +%Y%m%d)
        old_time=$(date -d "${old_date}" +%s)
        file_time=$(date +%s -r ${LOG_FILE})
        file_size=$(du ${LOG_FILE} | awk '{print $1}');
        if [ ${file_time} -le ${old_time} -o ${file_size} -gt 1024 ];
        then
            rm -rf ${LOG_FILE}
        fi
    fi
}

log()
{
    echo "$(date): $1" >> ${LOG_FILE}
}

fun_check_wifi_status()
{
    connected_dev_name=$(nmcli device status | awk '$2 == "wifi" && $3 == "connected" {print $1}'| tr "\n" " ")

    if [ -z $connected_dev_name ];
    then
        log "no wifi is connected"
        disconnected_dev_name=$(nmcli device status | awk '$2 == "wifi" && $3 == "disconnected" {print $1}'| tr "\n" " ")
        for item in ${disconnected_dev_name[@]}
        do    
            log "${item} try connect"
            nmcli device connect ${item} > /dev/null 2>&1
            sleep 2s
            connected_dev_name=$(nmcli device status | awk '$2 == "wifi" && $3 == "connected" {print $1}'| tr "\n" " ")
            if [ -z $connected_dev_name ];
            then
                log "next wifi device"
            else
                log "${connected_dev_name} is recovery connect"
                break
            fi
        done
    fi
}

check_cmd
del_log
log "start check wifi status"
while : 
do
    fun_check_wifi_status
    sleep 1s
done

