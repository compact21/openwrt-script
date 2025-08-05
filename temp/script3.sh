#!/bin/sh
# interval greater than the sum of the sleeps = 302 seconds
#
# if you want to run it with a crontab add this line into /etc/crontab.x/root
#
# cat /etc/crontab.x/root
# */6 * * * * /home/root/script3.sh

# for 600 sec from boot not exec nothing
statuptime=$(cut -f1 -d. /proc/uptime)
if [ "$statuptime" -lt "600" ]; then
exit 0
fi

ping -c 1 -W 1 8.8.8.8
if [ $? -ne "0" ]; then
    sleep 2
    ping -c 1 -W 1 1.1.1.1
    if [ $? -ne "0" ]; then
    logger "exec: /home/root/script3.sh \"sys resetcm\""
    sys resetcm
    sleep 300
    fi
fi
