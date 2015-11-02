#! /bin/sh

#NAME      SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT

#zpool list SSD64gb | awk '{ print "PoolName="$1", ""Size="$2", ""Allocated="$3}", ""PoolName="$1", ""Size="$2", ""Allocated="$3}", "'



for i in $(zpool list | awk 'NR>1' | awk '{print $1}')
do
        PoolName=`zpool list $i | awk 'NR>1' | awk '{print $1}'`
        Size=`zpool list $i  | awk 'NR>1' | awk '{print $2}'`
        Allocated=`zpool list $i  | awk 'NR>1' | awk '{print $3}'`
        Free=`zpool list $i  | awk 'NR>1' | awk '{print $4}'`
        EXPANDSZ=`zpool list $i  | awk 'NR>1' | awk '{print $5}'`
        FRAG=`zpool list $i | awk 'NR>1' | awk '{print $6}'`
        CAP=`zpool list $i  | awk 'NR>1' | awk '{print $7}'`
        DEDUP=`zpool list $i  | awk 'NR>1' | awk '{print $8}'`
        HEALTH=`zpool list $i  | awk 'NR>1' | awk '{print $9}'`
        ALTROOT=`zpool list $i  | awk 'NR>1' | awk '{print $10}'`
        echo PoolName=$PoolName, Size=$Size, Allocated=$Allocated, Free=$Free, EXPANDSZ=$EXPANDSZ, FRAG=$FRAG, CAP=$CAP, DEDUP=$DEDUP, HEALTH=$HEALTH, ALTROOT=$ALTROUT  | logger
done
