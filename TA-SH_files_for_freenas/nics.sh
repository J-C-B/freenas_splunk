#!/bin/sh
#Get nic info
for i in `ifconfig -ul`; do
        if [ "$i" != "lo0" ]; then
                h=`echo \$i | sed 's/[0-9]\{0,10\}\$//g'`
                j=`echo \$i | awk -F'[^0-9]*' '{print $2}'`
                sysctl -a | grep dev.$h.$j | sed 's/\:/\ \=/g' | logger
        fi
done
