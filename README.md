#Freenas app for Splunk

This repo contains a freenas app for Splunk®

http://www.freenas.org/

##Dashboards

###System Info

This Dashboard contains information on the freenas system(s)

![Example Dashboard](https://static.dyp.im/gKpG2D91QX/62eb965b0f5b06c26b89d52beaa078e5.png)

##Inputs

###.SH
There are several .sh scripts in /TA-SH_files_for_freenas directory that need to be placed on a persistent dataset on the freenas server with a cron job associated with them, set to run every few minutes.

https://doc.freenas.org/9.3/freenas_tasks.html

these scripts output to “logger” - which is the syslog output

also once copied over this may be your friend :)

```sh
chmod 777 foo.sh
```

###Syslog

You need to configure freenas to log to a central server (Splunk®) for the data to be ingested, point to port 1514 e.g. 

	192.168.1.2:1514

https://doc.freenas.org/9.3/freenas_system.html#general

###Local Weather input (Optional)

To compare local temps with system temps I added a json API input via http://openweathermap.org

Its free to signup - edit inputs.conf with your location information and appid (API key)


##VERY IMPORTANT NOTE

**This app is work in progress**

Please submit issues, improvements patches to github - http://j-c-b.github.io/freenas_splunk/

App is available directly on Splunkbase https://splunkbase.splunk.com/app/2940/#/overview

##TODO

* Snapshot script and dashboard
* ZFS related goodness for pools and datasets
