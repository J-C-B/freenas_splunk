#! /bin/sh

#NAME      SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
#11.2 adds field CKPOINT

for i in $(zpool list | awk 'NR>1' | awk '{print $1}')
do
        USED=$(zfs get used $i | grep used | awk '{print$3}'| sed s/T//g)
        FREE=$(zfs get available $i | grep available | awk '{print$3}'| sed s/T//g)
        SIZE=$(echo "$USED + $FREE" | bc)
        COMP=$(zfs get compressratio $i | grep comp | awk '{print$3}')
        echo PoolName=$i, Size=$SIZE\T, Allocated=$USED\T, Free=$FREE\T, EXPANDSZ=$(zpool get -H expandsize $i | awk '{print$3}'), FRAG=$(zpool get -H fragmentation $i | awk '{print$3}'), CAP=$(zpool get -H capacity $i | awk '{print$3}'), DEDUP=$(zpool get -H dedupratio $i | awk '{print$3}'), HEALTH=$(zpool get -H health $i | awk '{print$3}'), ALTROOT=$(zpool get -H altroot $i | awk '{print$3}'), Compression:$COMP | logger
done
