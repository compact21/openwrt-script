# Script per zyxel lte5398 m904 OEM firmware

Attenzione personalemente sono passato ad Openwrt ho aggiunto/modificato questi script in base alle richieste
di alcune persone che hanno mantenuto il firmware OEM, quindi non posso dare certezza assoluta se funzionano
oppure presentano problemi al massimo basta che mi fate sapere qualcosa

Quando ero sul firmware OEM la prima versione può essere recurerata qui:
<br/>
https://forum.fibra.click/d/39114-aggiornamento-firmware-zyxel-lte5398-m904/393

Le modifiche effettuate per alcune persone sono qui:
<br/>
https://forum.fibra.click/d/39114-aggiornamento-firmware-zyxel-lte5398-m904/1041

<br/>
<b>Ripeto non posso dare certezza assoluta se funzionano oppure presentano problemi.</b>

# attenzione la directory di root si trova in /home/root
su una versione standard la directoy corretta sarebbe /root

# attenzione il demone crontab si basa sulla directory /etc/crontab.x che non esiste
cat /etc/init.d/crond.sh | grep "crontab.x"
<br/>
su una versione standard la directoy corretta sarebbe /etc/crontabs

# download scritps
```
wget -c https://raw.githubusercontent.com/compact21/openwrt-script/refs/heads/main/temp/script3.sh
wget -c https://raw.githubusercontent.com/compact21/openwrt-script/refs/heads/main/temp/script4.sh
```

# renderli eseguibili
```
chmod 755 script3.sh
chmod 755 script4.sh
```

# creazione directory crontab
```
mkdir /etc/crontab.x
```

# creazione dell'elenco dei crontab
```
cd /etc/crontab.x
wget -c https://github.com/compact21/openwrt-script/blob/main/temp/root
```

# riavvio del servizio cron
```
/etc/init.d/crond.sh restart
```
