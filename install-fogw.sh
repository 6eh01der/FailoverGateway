#!/bin/bash

#Version: 1.1.2
#https://github.com/IBeholderI/FailoverGateway/blob/main/install-fogw.sh
if ! which fping
then
if which yum
then
        yum install -y fping
fi
if which dnf
then
        dnf install -y fping
fi
if which apt-get
then
        apt-get install -y fping
fi
if which apt
then
        apt install -y fping
fi
if which zypper
then
        zypper install -y fping
fi
fi
mkdir /opt/fogw
cp fogw.sh fogwcfg.sh uninstall-fogw.sh /opt/fogw/
cp fogw.service /etc/systemd/system/
cp fogw.timer /usr/lib/systemd/system/
read -p "Set gateways, ping timeout and auto failback on/off separated by spaces. First - default gateway, second - backup gateway, third - timeout in milliseconds like 700, fourth - auto failback on/off,(for example: 192.168.1.1 192.168.1.2 700 on): " ARGUMENTS
sed -i "6s/$/ $ARGUMENTS/" /etc/systemd/system/fogw.service
systemctl daemon-reload
systemctl enable fogw.timer
systemctl start fogw.timer
