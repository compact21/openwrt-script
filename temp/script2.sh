#!/bin/sh
touch /tmp/script2.lock
sys resetcm > /tmp/script2.lock 2>&1
