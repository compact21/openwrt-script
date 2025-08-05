#!/bin/sh
#
# if it runs with a crontab prevent it from being re-executed if file /tmp/script4.lock exists

# cat /etc/crontab.x/root
# * * * * * /home/root/script4.sh

# for 600 sec from boot not exec nothing
statuptime=$(cut -f1 -d. /proc/uptime)
if [ "$statuptime" -lt "600" ]; then
exit 0
fi

if [ ! -f /tmp/script4.lock ]; then
  ping -c 1 -W 1 8.8.8.8
  if [ $? -ne "0" ]; then
    sleep 2
    ping -c 1 -W 1 1.1.1.1
      if [ $? -ne "0" ]; then
      touch /tmp/script4.lock
      logger "exec: /home/root/script4.sh \"sys resetcm\""
      sys resetcm
      sleep 300
      rm /tmp/script4.lock
      fi
  fi
fi
