#! /bin/sh

#credits
# https://gist.github.com/i3luefire/242844141fde57d5cafd
# https://forums.freenas.org/index.php?threads/how-to-monitor-system-cpu-hdd-mobo-gpu-temperatures-on-freenas-8.2994/page-3

sysctl -a | egrep -E 'cpu\.[0-9]+\.temp' | cut -d'.' -f2 -f3 -f4 | tr -d ' ' | sed 's/\:/\=/g' | sed 's/cpu./cpuid\=/g' | sed 's/\./\,/g' | logger


#Get Free(nas|BSD) Version

if [ -f /etc/version ];
        then
                FreenasVersion=$(cat /etc/version)
        else
                FreenasVersion=$(uname -srm)
fi
echo FreenasVersion=$FreenasVersion | logger

#Get systemload

uptime | awk '{ print "SystemLoad1min="$10"\n""SystemLoad5min="$11"\n""SystemLoad10min="$12}"\n"' | logger

#Get Drive info

for i in $(sysctl -n kern.disks)
do

        CurrentDevSMART=`smartctl -a /dev/$i`
        Vendor="$(echo "$CurrentDevSMART" | awk '/Vendor:/{print $2}')"
        
        if [ ! -z $Vendor ]
        then
                DevModelFamily=`echo "$CurrentDevSMART" | awk '/Product:/{print $0}' | awk '{ print substr($0, index($0,$2)) }'`
                Dev_Current_Pending_Sector=`echo "$CurrentDevSMART" | awk '/Current_Pending_Sector/{print $0}' | awk -F " " '{print $NF}'`
                Dev_Offline_Uncorrectable=`echo "$CurrentDevSMART"  | awk '/Offline_Uncorrectable/{print $0}' | awk -F " " '{print $NF}'`
                DevName=`echo "$CurrentDevSMART" | awk '/Vendor:/{print $0}' | awk '{ print substr($0, index($0,$2)) }'`
                DevSerNum=`echo "$CurrentDevSMART" | awk '/Serial number:/{print $0}' | awk '{ print substr($0, index($0,$3)) }'`
                DevLU_WWN_Device_Id=`echo "$CurrentDevSMART" | awk '/Logical Unit id:/{print $0}' | awk '{ print substr($0, index($0,$4)) }'`
                DevFirmware_Version=`echo "$CurrentDevSMART" | awk '/Revision:/{print $0}' | awk '{ print substr($0, index($0,$2)) }'`
                DevUser_Capacity=`echo "$CurrentDevSMART" | awk '/User Capacity:/{print $0}' | awk '{ print substr($0, index($0,$3)) }' | sed 's/\,//g'`
                DevSector_Size=`echo "$CurrentDevSMART" | awk '/Logical block size:/{print $0}' | awk '{ print substr($0, index($0,$4)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevRotation_Rate=`echo "$CurrentDevSMART" | awk '/Rotation Rate:/{print $0}' | awk '{ print substr($0, index($0,$3)) }'`
                Dev_is=""
                DevSATA_Version=`echo "$CurrentDevSMART" | awk '/Transport protocol:/{print $0}' | awk '{ print substr($0, index($0,$3)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevATA_Version=""
                DevLocal_Time=`echo "$CurrentDevSMART" | awk '/Local Time is:/{print $0}' | awk '{ print substr($0, index($0,$4)) }'`
                DevSMART_support=`echo "$CurrentDevSMART" | awk '/SMART support is:/{print $0}' | awk '{ print substr($0, index($0,$4)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevTemp=`echo "$CurrentDevSMART" | awk '/Temperature_Celsius/ || /Current Drive Temperature:/{print $0}' | awk '$10>1 {print $10;next};{print $4}'`
        else
                DevModelFamily=`echo "$CurrentDevSMART" | awk '/Model Family:/{print $0}' | awk '{ print substr($0, index($0,$3)) }'`
                Dev_Current_Pending_Sector=`echo "$CurrentDevSMART"  | awk '/Current_Pending_Sector/{print $0}' | awk -F " " '{print $NF}'`
                Dev_Offline_Uncorrectable=`echo "$CurrentDevSMART"  | awk '/Offline_Uncorrectable/{print $0}' | awk -F " " '{print $NF}'`
                DevName=`echo "$CurrentDevSMART" | awk '/Device Model:/{print $0}' | awk '{ print substr($0, index($0,$3)) }'`
                DevSerNum=`echo "$CurrentDevSMART" | awk '/Serial Number:/{print $0}' | awk '{ print substr($0, index($0,$3)) }'`
                DevLU_WWN_Device_Id=`echo "$CurrentDevSMART" | awk '/LU WWN Device Id:/{print $0}' | awk '{ print substr($0, index($0,$5)) }'`
                DevFirmware_Version=`echo "$CurrentDevSMART" | awk '/Firmware Version:/{print $0}' | awk '{ print substr($0, index($0,$3)) }'`
                DevUser_Capacity=`echo "$CurrentDevSMART" | awk '/User Capacity:/{print $0}' | awk '{ print substr($0, index($0,$3)) }' | sed 's/\,//g'`
                DevSector_Size=`echo "$CurrentDevSMART" | awk '/Sector Size:/{print $0}' | awk '{ print substr($0, index($0,$3)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevRotation_Rate=""
                Dev_is=`echo "$CurrentDevSMART" | awk '/Device is:/{print $0}' | awk '{ print substr($0, index($0,$3)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevSATA_Version=`echo "$CurrentDevSMART" | awk '/SATA Version is:/{print $0}' | awk '{ print substr($0, index($0,$5)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevATA_Version=`echo "$CurrentDevSMART" | awk '/^ATA Version is:/{print $0}' | awk '{ print substr($0, index($0,$4)) }'| sed 's/\,//g' | sed 's/\ /_/g'`
                DevLocal_Time=`echo "$CurrentDevSMART" | awk '/Local Time is:/{print $0}' | awk '{ print substr($0, index($0,$4)) }'`
                DevSMART_support=`echo "$CurrentDevSMART" | awk '/SMART support is:/{print $0}' | awk '{ print substr($0, index($0,$4)) }' | sed 's/\,//g' | sed 's/\ /_/g'`
                DevTemp=`echo "$CurrentDevSMART" | awk '/Temperature_Celsius/{print $0}' | awk '{print $10}'`
        fi

    echo dev=$i, Dev_Current_Pending_Sector=$Dev_Current_Pending_Sector, Dev_Offline_Uncorrectable=$Dev_Offline_Uncorrectable, temperature=$DevTemp, DriveSerialNumber=$DevSerNum, DriveBrand=$DevName, DriveModel=$DevModelFamily, DevLU_WWN_Device_Id=$DevLU_WWN_Device_Id, DevFirmware_Version=$DevFirmware_Version, DevUser_Capacity=$DevUser_Capacity, DevSector_Size="$DevSector_Size", DevRotation_Rate="$DevRotation_Rate", Dev_is="$Dev_is", DevATA_Version=$DevATA_Version, DevSATA_Version="$DevSATA_Version", DevLocal_Time="$DevLocal_Time", DevSMART_support="$DevSMART_support" | logger
done

