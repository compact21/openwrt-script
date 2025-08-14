#!/bin/sh
# set -x; # enable debug

#
# run command at 2:00 add this line into /etc/crontab.x/root
#
# cat /etc/crontab.x/root
# 0 2 * * * /home/root/script3.sh

# for 600 sec from boot not exec nothing
statuptime=$(cut -f1 -d. /proc/uptime)
if [ "$statuptime" -lt "600" ]; then
exit 0
fi

logger "exec: /home/root/script3.sh"

touch /tmp/script3.lock

cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 0
cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 1

sleep 300

rm /tmp/script3.lock
