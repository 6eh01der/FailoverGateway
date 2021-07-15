#!/bin/bash

#Version: 1.1.6
#https://github.com/IBeholderI/FailoverGateway/blob/main/uninstall-fogw.sh

systemctl disable fogw.timer
rm -rf /opt/fogw
rm -f /usr/lib/systemd/system/fogw.timer
rm -f /etc/systemd/system/fogw.service
