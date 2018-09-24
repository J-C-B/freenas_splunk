#!/bin/sh

for i in $(/sbin/zpool list -H | awk '{print $1}')
do
        USED=$(/sbin/zfs get -Hp used $i | awk 'BEGIN{print "scale=1"}{print $3" / 1024 / 1024 / 1024 / 1024"}' | bc)
        FREE=$(/sbin/zfs get -Hp available $i | awk 'BEGIN{print "scale=1"}{print $3" / 1024 / 1024 / 1024 / 1024"}' | bc)
        SIZE=$(echo "$USED + $FREE" | bc)
        echo PoolName=$i, Size=$SIZE\T, Allocated=$USED\T, Free=$FREE\T, EXPANDSZ=$(/sbin/zpool get -H expandsize $i | awk '{print$3}'), FRAG=$(/sbin/zpool get -H fragmentation $i | awk '{print$3}'), CAP=$(/sbin/zpool get -H capacity $i | awk '{print$3}'), DEDUP=$(/sbin/zpool get -H dedupratio $i | awk '{print$3}'), HEALTH=$(/sbin/zpool get -H health $i | awk '{print$3}'), ALTROOT=$(/sbin/zpool get -H altroot $i | awk '{print$3}'), Compression=$(/sbin/zfs get -H compressratio $i | awk '{print$3}') | /usr/bin/logger -p local0.debug

done
