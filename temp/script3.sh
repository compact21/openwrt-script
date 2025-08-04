#!/bin/sh
# interval greater than the sum of the sleeps = 302 seconds
#
# if you want to run it with a crontab add this line into /etc/crontabs/root
#
# cat /etc/crontabs/root
# */6 * * * * /home/root/script3.sh

ping -c 1 -W 1 8.8.8.8
if [ $? -ne "0" ]; then
    sleep 2
    ping -c 1 -W 1 1.1.1.1
    if [ $? -ne "0" ]; then
    sys resetcm
    sleep 300
    fi
fi
