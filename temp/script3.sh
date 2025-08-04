#!/bin/sh
ping -c 1 -W 1 8.8.8.8
if [ $? -ne "0" ]; then
    sleep 2
    ping -c 1 -W 1 1.1.1.1
    if [ $? -ne "0" ]; then
    sys resetcm
    sleep 300
    fi
fi
