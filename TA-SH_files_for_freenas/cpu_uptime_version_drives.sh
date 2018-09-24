#! /bin/sh

#credits
# https://gist.github.com/i3luefire/242844141fde57d5cafd
# https://forums.freenas.org/index.php?threads/how-to-monitor-system-cpu-hdd-mobo-gpu-temperatures-on-freenas-8.2994/page-3
# Need full path (if not /bin /usr/bin) for FreeBSD 10.x

/sbin/sysctl -a | egrep -E 'cpu\.[0-9]+\.temp' | cut -d'.' -f2 -f3 -f4 | tr -d ' ' | sed 's/\:/\=/g' | sed 's/cpu./cpuid\=/g' | sed 's/\./\,/g' | /usr/bin/logger -p local0.debug


#Get Free(nas|BSD) Version

if [ -f /etc/version ];
        then
                FreenasVersion=$(cat /etc/version)
        else
                FreenasVersion=$(uname -srm | sed s/\ /-/g)
fi
echo FreenasVersion=$FreenasVersion | /usr/bin/logger -p local0.debug

#Get systemload

/usr/bin/uptime | /usr/bin/awk '{ print "SystemLoad1min="$10"\n""SystemLoad5min="$11"\n""SystemLoad10min="$12}"\n"' | /usr/bin/logger -p local0.debug

#Get Drive info

for i in $(/sbin/sysctl -n kern.disks)
do

        CurrentDevSMART=`/usr/local/sbin/smartctl -a /dev/$i`
        Vendor="$(echo "$CurrentDevSMART" | /usr/bin/awk '/Vendor:/{print $2}')"
        
        if [ ! -z $Vendor ]
        then
                DevModelFamily=`echo "$CurrentDevSMART" | /usr/bin/awk '/Product:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$2)) }'`
                Dev_Current_Pending_Sector=`echo "$CurrentDevSMART" | /usr/bin/awk '/Current_Pending_Sector/{print $0}' | /usr/bin/awk -F " " '{print $NF}'`
                Dev_Offline_Uncorrectable=`echo "$CurrentDevSMART"  | /usr/bin/awk '/Offline_Uncorrectable/{print $0}' | /usr/bin/awk -F " " '{print $NF}'`
                DevName=`echo "$CurrentDevSMART" | /usr/bin/awk '/Vendor:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$2)) }'`
                DevSerNum=`echo "$CurrentDevSMART" | /usr/bin/awk '/Serial number:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$3)) }'`
                DevLU_WWN_Device_Id=`echo "$CurrentDevSMART" | /usr/bin/awk '/Logical Unit id:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$4)) }'`
                DevFirmware_Version=`echo "$CurrentDevSMART" | /usr/bin/awk '/Revision:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$2)) }'`
                DevUser_Capacity=`echo "$CurrentDevSMART" | /usr/bin/awk '/User Capacity:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$3)) }' | sed 's/\,//g'`
                DevSector_Size=`echo "$CurrentDevSMART" | /usr/bin/awk '/Logical block size:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$4)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevRotation_Rate=`echo "$CurrentDevSMART" | /usr/bin/awk '/Rotation Rate:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$3)) }'`
                Dev_is=""
                DevSATA_Version=`echo "$CurrentDevSMART" | /usr/bin/awk '/Transport protocol:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$3)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevATA_Version=""
                DevLocal_Time=`echo "$CurrentDevSMART" | /usr/bin/awk '/Local Time is:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$4)) }'`
                DevSMART_support=`echo "$CurrentDevSMART" | /usr/bin/awk '/SMART support is:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$4)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevTemp=`echo "$CurrentDevSMART" | /usr/bin/awk '/Temperature_Celsius/ || /Current Drive Temperature:/{print $0}' | /usr/bin/awk '$10>1 {print $10;next};{print $4}'`
        else
                DevModelFamily=`echo "$CurrentDevSMART" | /usr/bin/awk '/Model Family:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$3)) }'`
                Dev_Current_Pending_Sector=`echo "$CurrentDevSMART"  | /usr/bin/awk '/Current_Pending_Sector/{print $0}' | /usr/bin/awk -F " " '{print $NF}'`
                Dev_Offline_Uncorrectable=`echo "$CurrentDevSMART"  | /usr/bin/awk '/Offline_Uncorrectable/{print $0}' | /usr/bin/awk -F " " '{print $NF}'`
                DevName=`echo "$CurrentDevSMART" | /usr/bin/awk '/Device Model:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$3)) }'`
                DevSerNum=`echo "$CurrentDevSMART" | /usr/bin/awk '/Serial Number:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$3)) }'`
                DevLU_WWN_Device_Id=`echo "$CurrentDevSMART" | /usr/bin/awk '/LU WWN Device Id:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$5)) }'`
                DevFirmware_Version=`echo "$CurrentDevSMART" | /usr/bin/awk '/Firmware Version:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$3)) }'`
                DevUser_Capacity=`echo "$CurrentDevSMART" | /usr/bin/awk '/User Capacity:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$3)) }' | sed 's/\,//g'`
                DevSector_Size=`echo "$CurrentDevSMART" | /usr/bin/awk '/Sector Size:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$3)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevRotation_Rate=""
                Dev_is=`echo "$CurrentDevSMART" | /usr/bin/awk '/Device is:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$3)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevSATA_Version=`echo "$CurrentDevSMART" | /usr/bin/awk '/SATA Version is:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$5)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevATA_Version=`echo "$CurrentDevSMART" | /usr/bin/awk '/^ATA Version is:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$4)) }'| sed 's/\,//g' | sed 's/\ /_/g'`
                DevLocal_Time=`echo "$CurrentDevSMART" | /usr/bin/awk '/Local Time is:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$4)) }'`
                DevSMART_support=`echo "$CurrentDevSMART" | /usr/bin/awk '/SMART support is:/{print $0}' | /usr/bin/awk '{ print substr($0, index($0,$4)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevTemp=`echo "$CurrentDevSMART" | /usr/bin/awk '/Temperature_Celsius/{print $0}' | /usr/bin/awk '{print $10}'`
        fi

    echo dev=$i, Dev_Current_Pending_Sector=$Dev_Current_Pending_Sector, Dev_Offline_Uncorrectable=$Dev_Offline_Uncorrectable, temperature=$DevTemp, DriveSerialNumber=$DevSerNum, DriveBrand=$DevName, DriveModel=$DevModelFamily, DevLU_WWN_Device_Id=$DevLU_WWN_Device_Id, DevFirmware_Version=$DevFirmware_Version, DevUser_Capacity=$DevUser_Capacity, DevSector_Size="$DevSector_Size", DevRotation_Rate="$DevRotation_Rate", Dev_is="$Dev_is", DevATA_Version=$DevATA_Version, DevSATA_Version="$DevSATA_Version", DevLocal_Time="$DevLocal_Time", DevSMART_support="$DevSMART_support" | /usr/bin/logger -p local0.debug
done

