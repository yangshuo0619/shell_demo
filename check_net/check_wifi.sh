#!/bin/bash
# x500 wifi dev name wlp13s0
fun_check_x500_wifi_status()
{
    dev_name=wlp13s0
    dis_dev_name=$(nmcli device status | awk '$2 == "wifi" && $3 == "disconnected" {print $1}'| tr "\n" " ")
    if [[ "$dis_dev_name" =~ $dev_name ]];
    then
        echo "$(date) :${dis_dev_name} is disconnected"
        nmcli device connect ${dev_name} > /dev/null 2>&1
        sleep 3s

    else
#        echo "$dis_dev_name is connected"
        :;
    fi
}
# single wifi dev
fun_check_wifi_status()
{
    dis_dev_name=$(nmcli device status | awk '$2 == "wifi" && $3 == "disconnected" {print $1}')
    if [ -z $dis_dev_name ];
    then
        echo "$dis_dev_name is connected"
    else
        echo "$dis_dev_name is disconnected"
        nmcli device connect ${dis_dev_name} > /dev/null 2>&1
        sleep 3s
    fi
}
# check wifi ip
fun_check_wifi_ip()
{
    dev_name=enp9s0
    
    ifconfig ${dev_name} > /dev/null 2>&1
    is_dev=$?
    if [ ${is_dev} -ne 0 ];
    then
        echo "${is_dev}:dev_name is not exist"
        exit
    fi

    ip_addr=$(ifconfig $dev_name | grep inet | awk -F'[ :]+' '{print $4}')
    echo ${ip_addr}
    if [ -z ${ip_addr} ];
    then
        echo "net is bad"
    else
        echo "net is ok"
    fi
}

while : 
do
    fun_check_x500_wifi_status
    sleep 1s
done

