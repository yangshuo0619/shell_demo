#!/bin/bash
# shell file runs as root

sudo cp -a interfaces /etc/network/interfaces
chmod 764 /etc/network/interfaces
# create net bridge br1
bridge_name="br1"
net_bridge_fd=$(ls /sys/class/net | grep br1)
if [ ! -n "$net_bridge_fd" ];then
  brctl addbr $bridge_name
  echo "net bridge is create"
else
  echo "net bridge is exist"
fi
sed -i '/ip_forward/c net.ipv4.ip_forward=1' /etc/sysctl.conf
sysctl -p
# clear old ip
sudo ip addr flush dev enp9s0
sudo ip addr flush dev enp10s0
sudo ip addr flush dev enp11s0
sudo ip addr flush dev enp12s0
sudo ip addr flush dev enp0s31f6
sudo ip addr flush dev enp8s0
# restart networking,net bridge is work
/etc/init.d/networking restart
