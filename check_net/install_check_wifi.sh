#!/bin/bash

sudo cp ./check_wifi.sh /usr/bin/
sudo cp ./check_wifi.service /etc/systemd/system/
sudo systemctl enable check_wifi.service

sudo systemctl daemon-reload
    
