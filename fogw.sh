#!/bin/bash

#*********************************************************************
#       Configuration
#*********************************************************************
DEF_GW="$1"      # Default Gateway
BCK_GW="$2"      # Backup Gateway
PING_TMO="$3"                # Ping timeout in milliseconds
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
        fping -c 2 -t "$PING_TMO" "$DEF_GW" &> /dev/null
        PING_DEF_GW=$?
                if [ "$PING_DEF_GW" != "0" ]
                then
                        fping -c 2 -t "$PING_TMO" "$BCK_GW" &> /dev/null
                        PING_BCK_GW=$?
                        if [ "$PING_BCK_GW" == "0" ]
                        then
                                # switching to backup
                                ip route del default
                                ip route add default via "$BCK_GW"
                                echo "Gateway switched to backup with IP \"$BCK_GW\""
                                        elif [ "$PING_BCK_GW" != "0" ]
                                        then
                                                echo "No gateways are reachable"
                        fi
                fi
elif [ "$CURT_GW" == "$BCK_GW" ]
then
        fping -c 2 -t "$PING_TMO" "$BCK_GW" &> /dev/null
        PING_BCK_GW=$?
# With automatic failback to default gateway when it comes up
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
# Without automatic failback to default gateway
: '
                if [ "$PING_BCK_GW" != "0" ]
                then
                        fping -c 2 -t "$PING_TMO" "$DEF_GW" &> /dev/null
                        PING_DEF_GW=$?
                        if [ "$PING_DEF_GW" == "0" ]
                        then
                                # Switching to default
                                ip route del default
                                ip route add default via "$DEF_GW"
                                echo "Gateway switched to Default with IP \"$DEF_GW\""
                        elif [ "$PING_DEF_GW" != "0" ] && [ "$PING_BCK_GW" != "0" ]
                        then
                                echo "No gateways available"
                        fi
                fi
'
fi
