#!/bin/sh
# set -x; # enable debug
# shellcheck disable=SC2181,SC2034

# se vuoi che venga eseguito segui la documentazione e definisci il tempo minimo fra due passaggi
# esempio:
# cat /etc/crontab.x/root
# * * * * * /home/root/script.sh

TARGET="8.8.8.8"
CURLTARGET="www.google.com"
LOGFILE="/tmp/logfile"

# per 600 secondi dal boot del router non fa nulla (attenzione partizioni non persistenti)
# dovrai riscaricare lo o gli script
statuptime=$(cut -f1 -d. /proc/uptime)
if [ "$statuptime" -lt "600" ]; then
exit 0
fi

if [ -f "$LOGFILE" ]; then
lines=$(grep -c ^ "$LOGFILE")
  if [ "$lines" -gt "1000" ]; then
  # quando il log diventa troppo grande superiore a 1000 righe
  # rimuovi le linee eccedenti se si superano 1000 righe di log
  keep_me=$(tail -100 "$LOGFILE") && echo "$keep_me" > "$LOGFILE"
  echo "$(date) exec: pulizia del $LOGFILE" >> "$LOGFILE"
  fi
else
touch "$LOGFILE"
fi

if [ ! -f /tmp/script.lock ]; then

# test di connessione con curl
#curl -sf "$CURLTARGET" -o /dev/null

# test di connessione con ping
ping -c 1 -W 1 "$TARGET"

  if [ $? -ne "0" ]; then
  touch /tmp/script.lock

  # versione originale (modificata in quanto mi hanno detto che non funziona sempre)
  #udhcpc -i wwan0 > /tmp/script.lock 2>&1

  # versione attuale (in attesa di riscontro se funziona sempre)
  echo "$(date) exec: cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 0" >> "$LOGFILE"
  cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 0 > "$LOGFILE" 2>&1
  sleep 2
  echo "$(date) exec: cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 1" >> "$LOGFILE"
  cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 1 > "$LOGFILE" 2>&1
  sleep 120

  rm /tmp/script.lock
  else
  logger "ping -c 1 -W 1 $TARGET good"
  echo "$(date) exec: ping -c 1 -W 1 $TARGET good" >> "$LOGFILE"
  fi
  
else
logger "warning non posso far ripartire /home/root/script.sh; exit 0"
echo "$(date) exec: /home/root/script.sh il file /tmp/script.lock esiste non posso fare nulla" >> "$LOGFILE"
exit 0
fi
