#Freenas app for Splunk

This repo contains a freenas app for Splunk®

http://www.freenas.org/

##Inputs

###.SH
There are several .sh scripts in /bin directory that need to be placed on a persistent dataset on the freenas server with a cron job associated with them, set to run every few minutes.

https://doc.freenas.org/9.3/freenas_tasks.html

these scripts output to “logger” - which is the syslog output

###Syslog

You need to configure freenas to log to a central server (Splunk®) for the data to be ingested, point to port 1514 e.g. 

	192.168.1.2:1514

https://doc.freenas.org/9.3/freenas_system.html#general

###Local Weather input (Optional)

To compare local temps with system temps I added a json API input via http://openweathermap.org

Its free to signup - edit inputs.conf with your location information and appid (API key)

##VERY IMPORTANT NOTE

**This app is incomplete**
