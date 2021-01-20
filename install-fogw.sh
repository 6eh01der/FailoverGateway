#!/bin/bash
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
read -p "Set gateways and ping timeout separated by spaces. First - default gateway, second - backup gateway, third - timeout in milliseconds like 500(default value),(for example: 192.168.1.1 192.168.1.2 700): " ARGUMENTS
sed -i "6s/$/ $ARGUMENTS/" /etc/systemd/system/fogw.service
systemctl daemon-reload
read -p "Enable automatic failback to default gateway when it comes up? (yes/no) " ANSWER
if [ "$ANSWER" == no ]
then
sed -i "36a : '" /opt/fogw/fogw.sh
sed -i "49a '" /opt/fogw/fogw.sh
sed -i '52d;65d' /opt/fogw/fogw.sh
fi
systemctl enable fogw.timer
systemctl start fogw.timer
