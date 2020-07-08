#!/bin/bash
# shell file runs as root

dpkg_bridge_utils=$(dpkg -s bridge-utils)
if [ -n "$dpkg_bridge_utils" ];then
  dpkg -r bridge-utils
  echo "bridge-utils is exist,and remove it."
fi
dpkg -i ./deb/bridge-utils_1.5-9ubuntu1_amd64.deb

