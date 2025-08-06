#!/bin/sh

# for 600 sec from boot not exec nothing
statuptime=$(cut -f1 -d. /proc/uptime)
if [ "$statuptime" -lt "600" ]; then
exit 0
fi

#touch /tmp/script.lock

#udhcpc -i wwan0 > /tmp/script.lock 2>&1

cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 0
cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 1
