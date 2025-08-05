#!/bin/sh
touch /tmp/script.lock
udhcpc -i wwan0 > /tmp/script.lock 2>&1
