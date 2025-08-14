#!/bin/sh
# set -x; # enable debug

# se vuoi che venga eseguito segui la documentazione e definisci il tempo minimo fra due passaggi
# esempio:
# cat /etc/crontab.x/root
# * * * * * /home/root/script.sh

TARGET="8.8.8.8"

# per 600 secondi dal boot del router non fa nulla (attenzione partizioni non persistenti)
# dovrai riscaricare lo o gli script
statuptime=$(cut -f1 -d. /proc/uptime)
if [ "$statuptime" -lt "600" ]; then
exit 0
fi

if [ ! -f /tmp/script.lock ]; then
ping -c 1 -W 1 "$TARGET"
  if [ $? -ne "0" ]; then
  touch /tmp/script.lock

  # versione originale (modificata in quanto mi hanno detto che non funziona sempre)
  #udhcpc -i wwan0 > /tmp/script.lock 2>&1

  # versione attuale (in attesa di riscontro se funziona sempre)
  cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 0
  sleep 2
  cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 1
  sleep 120

  rm /tmp/script.lock
  else
  logger "ping -c 1 -W 1 $TARGET good"
  fi
else
logger "warning non posso far ripartire /home/root/script.sh; exit 0"
exit 0
fi
