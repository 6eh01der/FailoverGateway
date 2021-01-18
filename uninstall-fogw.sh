#!/bin/bash

systemctl disable fogw.timer
rm -rf /opt/fogw
rm -f /usr/lib/systemd/system/fogw.timer
rm -f /etc/systemd/system/fogw.service