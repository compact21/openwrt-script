#!/bin/sh

tries=0
while [[ $tries -lt 5 ]]
do
if /bin/ping -c 1 8.8.8.8 >/dev/null
then
exit 0
fi
tries=$((tries+1))
done

/etc/init.d/network restart
