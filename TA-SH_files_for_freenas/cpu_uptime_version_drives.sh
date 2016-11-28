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

        DevModelFamily=`smartctl -a /dev/$i | awk '/Model Family:/{print $0}' | awk '{ print substr($0, index($0,$3)) }'`
        DevName=`smartctl -a /dev/$i | awk '/Device Model:/{print $0}' | awk '{ print substr($0, index($0,$3)) }'`
        DevSerNum=`smartctl -a /dev/$i | awk '/Serial Number:/{print $0}' | awk '{ print substr($0, index($0,$3)) }'`
        DevLU_WWN_Device_Id=`smartctl -a /dev/$i | awk '/LU WWN Device Id:/{print $0}' | awk '{ print substr($0, index($0,$5)) }'`
        DevFirmware_Version=`smartctl -a /dev/$i | awk '/Firmware Version:/{print $0}' | awk '{ print substr($0, index($0,$3)) }'`
        DevUser_Capacity=`smartctl -a /dev/$i | awk '/User Capacity:/{print $0}' | awk '{ print substr($0, index($0,$3)) }' | sed 's/\,//g'`
        DevSector_Size=`smartctl -a /dev/$i | awk '/Sector Size:/{print $0}' | awk '{ print substr($0, index($0,$3)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
        Dev_is=`smartctl -a /dev/$i | awk '/Device is:/{print $0}' | awk '{ print substr($0, index($0,$3)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
        DevSATA_Version=`smartctl -a /dev/$i | awk '/SATA Version is:/{print $0}' | awk '{ print substr($0, index($0,$5)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
        DevATA_Version=`smartctl -a /dev/$i | awk '/^ATA Version is:/{print $0}' | awk '{ print substr($0, index($0,$4)) }'| sed 's/\,//g' | sed 's/\ /_/g'`
        DevLocal_Time=`smartctl -a /dev/$i | awk '/Local Time is:/{print $0}' | awk '{ print substr($0, index($0,$4)) }'`
        DevSMART_support=`smartctl -a /dev/$i | awk '/SMART support is:/{print $0}' | awk '{ print substr($0, index($0,$4)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
        DevATA_Version=`smartctl -a /dev/$i | awk '/ATA Version is:/{print $0}' | awk '{ print substr($0, index($0,$4)) }' | sed 's/\,//g' | sed 's/\ /_/g'`


        DevTemp=`smartctl -a /dev/$i | awk '/Temperature_Celsius/{print $0}' | awk '{print $10}'`
        echo dev=$i, temperature=$DevTemp, DriveSerialNumber=$DevSerNum, DriveBrand=$DevName, DriveModel=$DevModelFamily, DevLU_WWN_Device_Id=$DevLU_WWN_Device_Id, DevFirmware_Version=$DevFirmware_Version, DevUser_Capacity=$DevUser_Capacity, DevSector_Size="$DevSector_Size", DevRotation_Rate="$DevRotation_Rate", Dev_is="$Dev_is", DevATA_Version=$DevATA_Version, DevSATA_Version="$DevSATA_Version", DevLocal_Time="$DevLocal_Time", DevSMART_support="$DevSMART_support"| logger
done
