#!/bin/sh
#
# if it runs with a crontab prevent it from being re-executed if file /tmp/script4.lock exists
# as I have no idea if there is a possibility to run a crontab with flock on this system
# https://man7.org/linux/man-pages/man1/flock.1.html
#
# cat /etc/crontabs/root
# * * * * * /home/root/script4.sh
# * * * * * flock -n /tmp/script3.lock /home/root/script3.sh
#

# for 600 sec from boot not exec nothing
if [ $(awk -F "." '{print $1}' /proc/uptime) -lt "600" ]; then
exit 0
fi

if [ ! -f /tmp/script4.lock ]; then
  ping -c 1 -W 1 8.8.8.8
  if [ $? -ne "0" ]; then
    sleep 2
    ping -c 1 -W 1 1.1.1.1
      if [ $? -ne "0" ]; then
      touch /tmp/script4.lock
      sys resetcm
      sleep 300
      rm /tmp/script4.lock
      fi
  fi
fi
