#!/bin/bash

#Version: 1.1.2
#https://github.com/IBeholderI/FailoverGateway/blob/main/install-fogw.sh
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
                if fping -c 2 -t "$PING_TMO" "$DEF_GW" &> /dev/null
                then
                        if fping -c 2 -t "$PING_TMO" "$BCK_GW" &> /dev/null
                        then
                                # switching to backup
                                ip route del default
                                ip route add default via "$BCK_GW"
                                echo "Gateway switched to backup with IP \"$BCK_GW\""
                        else
                                echo "No gateways are reachable"
                        fi
                fi
elif [ "$CURT_GW" == "$BCK_GW" ]
then
        fping -c 2 -t "$PING_TMO" "$BCK_GW" &> /dev/null
        PING_BCK_GW=$?
case $AUTO_FB in
# With automatic failback to default gateway when it comes up
yes)
        fping -c 2 -t "$PING_TMO" "$DEF_GW" &> /dev/null
        PING_DEF_GW=$?
                if { [ "$PING_DEF_GW" == "0" ] && [ "$PING_BCK_GW" == "0" ]; } || { [ "$PING_DEF_GW" == "0" ] && [ "$PING_BCK_GW" != "0" ]; }
                then
                        # switching to default
                        ip route del default
                        ip route add default via "$DEF_GW"
                        echo "Gateway switched to default with IP \"$DEF_GW\""
                                elif [ "$PING_DEF_GW" != "0" ] && [ "$PING_BCK_GW" != "0" ]
                                then
                                        echo "No gateways are reachable"
                fi
;;
# Without automatic failback to default gateway
no)
                if [ "$PING_BCK_GW" != "0" ]
                then
                        if fping -c 2 -t "$PING_TMO" "$DEF_GW" &> /dev/null
                        then
                                # Switching to default
                                ip route del default
                                ip route add default via "$DEF_GW"
                                echo "Gateway switched to Default with IP \"$DEF_GW\""
                        else
                                echo "No gateways available"
                        fi
                fi
;;
esac
fi
