#FreeNAS app for Splunk

This repo contains a FreeNAS app for Splunk®

##FreeNAS

http://www.freenas.org/

FreeNAS is a powerful, flexible home storage system – configured by you, for your needs.

###ZFS
The Z File System, or ZFS , is an advanced file system designed to overcome many of the major problems found in previous designs. 

##Splunk®
http://www.splunk.com/en_us/download/splunk-enterprise.html

Splunk Enterprise is the leading platform for real-time operational intelligence. When you download Splunk Enterprise for free, you get a Splunk Enterprise license for 60 days that lets you index up to 500 megabytes of data per day.

When the free trial ends, you can convert to a perpetual Free license or purchase an Enterprise license to continue using the expanded functionality designed for multi-user deployments.

##Dashboards

###System Info

This Dashboard contains information on the FreeNAS system(s)

![Example Dashboard](https://static.dyp.im/gKpG2D91QX/62eb965b0f5b06c26b89d52beaa078e5.png)

##Inputs

###.SH
There are several .sh scripts in /TA-SH_files_for_FreeNAS directory that need to be placed on a persistent dataset on the FreeNAS server with a cron job associated with them, set to run every few minutes.

https://doc.freenas.org/9.3/freenas_tasks.html

these scripts output to “logger” - which is the syslog output

also once copied over this may be your friend :)

```sh
chmod 777 foo.sh
```

###Syslog

You need to configure FreeNAS to log to a central server (Splunk®) for the data to be ingested, point to port 1514 e.g. 

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

* Snapshot script and dashboard for success / fail
* ZFS related goodness for pools and datasets
* Improve dashboard search efficiency
* Use ipmiOutput for host data input
