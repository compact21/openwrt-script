#!/bin/sh
# set -x; # enable debug
# shellcheck disable=SC2181,SC2034

# se vuoi che venga eseguito segui la documentazione e definisci il tempo minimo fra due passaggi
# esempio:
# cat /etc/crontab.x/root
# * * * * * /home/root/script.sh

# -----------------------------------------------------
# Elenco variabili

# dove provare ad effettuare il ping
TARGET="8.8.8.8"

# dove provare ad effettuare uno scaricamento
CURLTARGET="www.google.com"

# abilitare il log su file ricordarsi poi di disabilitare questa funzione ed eliminare i files
#ENABLELOGFILE="1"; # decommentare questa righa per abilitare il log su file
DIRLOGFILE="/tmp/debug/"; # creazione di una directory dove salvare i file solo se ENABLELOGFILE=1
LOGFILE="/tmp/debug/logfile-$(date +%d-%m-%Y).log"; # creazione dei file di log in formato logfile-giorno-mese-anno.log solo se ENABLELOGFILE=1

# -----------------------------------------------------
# per 600 secondi dal boot del router non fa nulla

statuptime=$(cut -f1 -d. /proc/uptime)
if [ "$statuptime" -lt "600" ]; then
exit 0
fi

# -----------------------------------------------------
# creazione della directory e dei log su file

if [ "$ENABLELOGFILE" -eq 1 ]; then
  if [ ! -d "$DIRLOGFILE" ]; then
  mkdir "$DIRLOGFILE"
  fi
fi

if [ "$ENABLELOGFILE" -eq 1 ]; then
  if [ ! -f "$LOGFILE" ]; then
  touch "$LOGFILE"
  fi
fi

# -----------------------------------------------------
# inizio script

if [ ! -f /tmp/script.lock ]; then

# test di connessione con curl
#curl -sf "$CURLTARGET" -o /dev/null

# test di connessione con ping
ping -c 1 -W 1 "$TARGET"

if [ $? -ne "0" ]; then
  # -----------------------------------------------------
  # creazione di un file di lock impedisce allo script di essere rieseguito nello stesso istante in cui stà già girando
  touch /tmp/script.lock

  # -----------------------------------------------------
  # versione originale modificata in quanto mi hanno detto che il comando seguente non funziona sempre
  #udhcpc -i wwan0 > /tmp/script.lock 2>&1

  if [ "$ENABLELOGFILE" -eq "1" ]; then
  echo "$(date) exec: cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 0" >> "$LOGFILE"
  fi
    
  # -----------------------------------------------------
  # versione attuale in attesa di riscontro se funziona sempre
  cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 0 > "$LOGFILE" 2>&1
  sleep 2
  
  if [ "$ENABLELOGFILE" -eq "1" ]; then
  echo "$(date) exec: cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 1" >> "$LOGFILE"
  fi
  
  # -----------------------------------------------------
  # versione attuale in attesa di riscontro se funziona sempre
  cfg cellwan_mapn edit --Index 1 --AP_ManualAPN 1 > "$LOGFILE" 2>&1
  sleep 120

  # -----------------------------------------------------
  # rimozione del file di lock che impedisce allo script di essere rieseguito
  rm /tmp/script.lock

  else

  # -----------------------------------------------------
  # log dell'esisto del ping (se necessario)
  logger "ping -c 1 -W 1 $TARGET good"
    if [ "$ENABLELOGFILE" -eq "1" ]; then
    echo "$(date) exec: ping -c 1 -W 1 $TARGET good" >> "$LOGFILE"
    fi
  
  fi
  
else

  # -----------------------------------------------------
  # log non può essere eseguito lo script in questo momento
  logger "warning non posso far ripartire /home/root/script.sh; exit 0"
    if [ "$ENABLELOGFILE" -eq "1" ]; then
    echo "$(date) exec: /home/root/script.sh il file /tmp/script.lock esiste non posso fare nulla" >> "$LOGFILE"
    fi
  exit 0
  
fi
