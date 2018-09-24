#!/bin/sh
#Get nic info
for i in `/sbin/ifconfig -ul`; do
        if [ "$i" != "lo0" ]; then
                h=`echo \$i | /usr/bin/sed 's/[0-9]\{0,10\}\$//g'`
                j=`echo \$i | /usr/bin/awk -F'[^0-9]*' '{print $2}'`
                /sbin/sysctl -a | grep dev.$h.$j | sed 's/\:/\ \=/g' | /usr/bin/logger -p local0.debug
        fi
done
