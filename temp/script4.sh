#!/bin/sh
#
# if it runs with a crontab prevent it from being re-executed if file /tmp/script4.lock exists

# cat /etc/crontab.x/root
# */2 * * * * /home/root/script4.sh

# for 600 sec from boot not exec nothing
statuptime=$(cut -f1 -d. /proc/uptime)
if [ "$statuptime" -lt "600" ]; then
exit 0
fi

logger "exec: /home/root/script4.sh"

# prevent exectution this script, actual run /home/root/scritp3.sh at 2:00
if [ -f /tmp/script3.lock ]; then
logger "warning run /home/root/script3.sh; exit 0"
exit 0
fi

if [ ! -f /tmp/script4.lock ]; then
  ping -c 1 -W 10 8.8.8.8
  if [ $? -ne "0" ]; then
    sleep 2
    ping -c 1 -W 10 1.1.1.1
      if [ $? -ne "0" ]; then
      touch /tmp/script4.lock
      logger "exec: /home/root/script4.sh cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 0"
      cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 0
      sleep 2
      logger "exec: /home/root/script4.sh cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 1"
      cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 1
      sleep 120
      rm /tmp/script4.lock
      else
      logger "ping -c 1 -W 10 1.1.1.1 good"
      fi
  else
  logger "ping -c 1 -W 10 8.8.8.8 good"
  fi
fi
