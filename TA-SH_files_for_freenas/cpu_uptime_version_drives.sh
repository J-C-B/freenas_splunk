#! /bin/sh

#credits
# https://gist.github.com/i3luefire/242844141fde57d5cafd
# https://forums.freenas.org/index.php?threads/how-to-monitor-system-cpu-hdd-mobo-gpu-temperatures-on-freenas-8.2994/page-3

sysctl -a | egrep -E 'cpu\.[0-9]+\.temp' | cut -d'.' -f2 -f3 -f4 | tr -d ' ' | sed 's/\:/\=/g' | sed 's/cpu./cpuid\=/g' | sed 's/\./\,/g' | logger


#Get Freenas Version

FreenasVersion=$(cat /etc/version)

echo FreenasVersion=$FreenasVersion | logger


#Get systemload

uptime | awk '{ print "SystemLoad1min="$10"\n""SystemLoad5min="$11"\n""SystemLoad10min="$12}"\n"' | logger


#
#
# Define adastat function, which writes drive activity to temp file
#adastat () {
#  CM=$(camcontrol cmd $1 -a "E5 00 00 00 00 00 00 00 00 00 00 00" -r - | awk '{print $10}')
#  if [ "$CM" = "FF" ] ; then
#  echo " SPINNING" >> $LOGFILE
#  elif [ "$CM" = "00" ] ; then
#  echo " IDLE" >> $LOGFILE
#  else
#  echo " UNKNOWN ($CM)" >> $LOGFILE
#  fi
#}


#Get Drive info

for i in $(sysctl -n kern.disks)
do
        DevTemp=`smartctl -a /dev/$i | awk '/Temperature_Celsius/{print $0}' | awk '{print $10}'`
        DevSerNum=`smartctl -a /dev/$i | awk '/Serial Number:/{print $0}' | awk '{print $3}'`
        DevName=`smartctl -a /dev/$i | awk '/Device Model:/{print $0}' | awk '{print $4}'`
	DevModelFamily=`smartctl -a /dev/$i | awk '/Model Family:/{print $0}' | awk '{ print substr($0, index($0,$3)) }'`
        echo dev=$i, temperature=$DevTemp, DriveSerialNumber=$DevSerNum, DriveBrand=$DevName, DriveModel=$DevModelFamily
done
