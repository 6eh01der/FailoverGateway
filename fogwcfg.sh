#!/bin/bash

#Version: 1.1.6
#https://github.com/IBeholderI/FailoverGateway/blob/main/fogwcfg.sh

read -p "Set gateways, ping timeout and auto failback on/off separated by spaces. First - default gateway, second - backup gateway, third - timeout in milliseconds like 700, fourth - auto failback on/off,(for example: 192.168.1.1 192.168.1.2 700 on): " ARGUMENTS
sed -i "s/^ExecStart.*$/ExecStart=\/opt\/fogw\/fogw.sh $ARGUMENTS/" /etc/systemd/system/fogw.service
systemctl daemon-reload
