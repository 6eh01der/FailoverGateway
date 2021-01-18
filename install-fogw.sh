#!/bin/bash

mkdir /opt/fogw
cp fogw.sh fogwcfg.sh uninstall-fogw.sh /opt/fogw/
cp fogw.service /etc/systemd/system/
cp fogw.timer /usr/lib/systemd/system/
read -p "Set gateways and ping timeout separated by spaces. First - default gateway, second - backup gateway, third - timeout in seconds like 1,(for example: 192.168.1.1 192.168.1.2 1): " ARGUMENTS
sed -i "6s/$/ $ARGUMENTS/" /etc/systemd/system/fogw.service
systemctl daemon-reload
read -p "Enable automatic failback to default gateway when it comes up? (Yes/No) " ANSWER
if [ $ANSWER == No ]
then
sed -i "41a : '" /opt/fogw/fogw.sh
sed -i "54a '" /opt/fogw/fogw.sh
sed -i '57d;73d' /opt/fogw/fogw.sh
fi
systemctl enable fogw.timer
systemctl start fogw.timer