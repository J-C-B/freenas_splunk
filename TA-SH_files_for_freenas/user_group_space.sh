#!/usr/bin/env bash
 
declare -A GroupSpace
while read key value; do ((GroupSpace[$key] += value)); done < <(while read line; do /sbin/zfs groupspace -Hp -o name,used $line; done < <(/sbin/zfs list -H | awk '{print $1}'))
for key in "${!GroupSpace[@]}"; do echo "GroupName $key" ${GroupSpace[$key]}; done | logger -p local0.debug

declare -A UserSpace
while read key value; do ((UserSpace[$key] += value)); done < <(while read line; do /sbin/zfs userspace -Hp -o name,used $line; done < <(/sbin/zfs list -H | awk '{print $1}'))
for key in "${!UserSpace[@]}"; do echo "UserName $key" ${UserSpace[$key]}; done | logger -p local0.debug

