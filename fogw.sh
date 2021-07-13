#!/bin/bash

#Version: 1.1.5
#https://github.com/IBeholderI/FailoverGateway/blob/main/fogw.sh
#*********************************************************************
#       Configuration
#*********************************************************************
DEF_GW="$1"      # Default Gateway
BCK_GW="$2"      # Backup Gateway
PING_TMO="$3"    # Ping timeout in milliseconds
AUTO_FB="$4"     # Auto failback on/off
#*********************************************************************

#Check GW
CURT_GW=$(ip route show | grep default | awk '{ print $3 }')
if [ -z "${CURT_GW}" ]
then
        ip route add default via "$DEF_GW"
        echo "Default gateway with IP \"$DEF_GW\" was set"
fi
if [ "$CURT_GW" == "$DEF_GW" ]
then
                if ! fping -c 2 -t "$PING_TMO" "$DEF_GW" &> /dev/null
                then
                        if fping -c 2 -t "$PING_TMO" "$BCK_GW" &> /dev/null
                        then
                                # switching to backup
                                ip route del default
                                ip route add default via "$BCK_GW"
                                echo "Gateway switched to backup with IP \"$BCK_GW\""
                                exit 0
                        else
                                echo "No gateways are reachable"
                                exit 1
                        fi
                fi
elif [ "$CURT_GW" == "$BCK_GW" ]
then
case $AUTO_FB in
# With automatic failback to default gateway when it comes up
on)
        fping -c 2 -t "$PING_TMO" "$BCK_GW" &> /dev/null
        PING_BCK_GW=$?
        fping -c 2 -t "$PING_TMO" "$DEF_GW" &> /dev/null
        PING_DEF_GW=$?
                if [ "$PING_DEF_GW" == "0" ]
                then
                        # switching to default
                        ip route del default
                        ip route add default via "$DEF_GW"
                        echo "Gateway switched to default with IP \"$DEF_GW\""
                        exit 0
                elif [ "$PING_BCK_GW" != "0" ]
                then
                        echo "No gateways are reachable"
                        exit 1
                fi
;;
# Without automatic failback to default gateway
off)
                if ! fping -c 2 -t "$PING_TMO" "$BCK_GW" &> /dev/null
                then
                        if fping -c 2 -t "$PING_TMO" "$DEF_GW" &> /dev/null
                        then
                                # Switching to default
                                ip route del default
                                ip route add default via "$DEF_GW"
                                echo "Gateway switched to Default with IP \"$DEF_GW\""
                                exit 0
                        else
                                echo "No gateways are reachable"
                                exit 1
                        fi
                fi
;;
esac
elif [ "$CURT_GW" != "$DEF_GW" ] && [ "$CURT_GW" != "$BCK_GW" ]
then
echo "fogw configured gateways are different then currently used. Current default gateway must be empty or the same as default or backup gateway placed in fogw config or maybe fogw gateways config is wrong."
exit 1
fi
