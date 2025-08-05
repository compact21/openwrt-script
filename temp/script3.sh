#!/bin/sh
# 
# run command at 3:00 add this line into /etc/crontab.x/root
#
# cat /etc/crontab.x/root
# 0 3 * * * /home/root/script3.sh

# for 600 sec from boot not exec nothing
statuptime=$(cut -f1 -d. /proc/uptime)
if [ "$statuptime" -lt "600" ]; then
exit 0
fi

logger "exec: /home/root/script3.sh \"sys resetcm\""
touch /tmp/script3.lock
sys resetcm
sleep 300
rm /tmp/script3.lock
