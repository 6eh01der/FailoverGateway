#!/bin/bash
which yum
if [ $? == "0" ]
then 
        yum install -y fping
fi
which dnf
if [ $? == "0" ]
then
        dnf install -y fping
fi
which apt-get
if [ $? == "0" ]
then
        apt-get install -y fping
fi
which apt
if [ $? == "0" ]
then
        apt install -y fping
fi
which zypper
if [ $? == "0" ]
then
        zypper install -y fping
fi
mkdir /opt/fogw
cp fogw.sh fogwcfg.sh uninstall-fogw.sh /opt/fogw/
cp fogw.service /etc/systemd/system/
cp fogw.timer /usr/lib/systemd/system/
read -p "Set gateways and ping timeout separated by spaces. First - default gateway, second - backup gateway, third - timeout in milliseconds like 500(default value),(for example: 192.168.1.1 192.168.1.2 700): " ARGUMENTS
sed -i "6s/$/ $ARGUMENTS/" /etc/systemd/system/fogw.service
systemctl daemon-reload
read -p "Enable automatic failback to default gateway when it comes up? (yes/no) " ANSWER
if [ $ANSWER == no ]
then
sed -i "41a : '" /opt/fogw/fogw.sh
sed -i "54a '" /opt/fogw/fogw.sh
sed -i '57d;73d' /opt/fogw/fogw.sh
fi
systemctl enable fogw.timer
systemctl start fogw.timer
