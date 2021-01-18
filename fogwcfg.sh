#!/bin/bash

read -p "Set gateways and ping timeout separated by spaces. First - default gateway, second - backup gateway, third - timeout in seconds like 1,(for example: 192.168.1.1 192.168.1.2 1): " ARGUMENTS
sed -i "s/^ExecStart.*$/ExecStart=\/opt\/fogw\/fogw.sh $ARGUMENTS/" /etc/systemd/system/fogw.service
systemctl daemon-reload