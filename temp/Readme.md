# Script per zyxel lte5398 m904 OEM firmware

Attenzione personalmente sono passato ad Openwrt
<br/>
ho aggiunto/modificato questi script in base alle richieste di alcune persone che hanno mantenuto il firmware OEM,
<br/>
quindi non posso dare certezza assoluta se funzionano oppure presentano problemi al massimo basta che mi fate sapere qualcosa

Quando ero sul firmware OEM la prima versione può essere recurerata qui:
<br/>
https://forum.fibra.click/d/39114-aggiornamento-firmware-zyxel-lte5398-m904/393

Le modifiche effettuate per alcune persone sono qui:
<br/>
https://forum.fibra.click/d/39114-aggiornamento-firmware-zyxel-lte5398-m904/1041

<br/>
Da una vecchia documentazione mi risulta che non è presente il comando <b>wget</b> viene modificata la documentazione per l'utilizzo di <b>curl</b>
<br/>

<br/>
<b>Ripeto non posso dare certezza assoluta se funzionano oppure presentano problemi.</b>


# attenzione il firwmare OEM è stato proggettato in questa maniera

le partizioni sembrano montate in lettura e scrittura, ma riavviano il router si nota che eventuali file creati prima del "reboot"
<br/>
non sono più presenti quindi le partizioni non sono persistenti.
<br/>

il modulo LTE all'interno del router "EG18-EU" sul firmware OEM è gestito con la modalità "QMI"
<br/>


# attenzione la directory di root si trova in /home/root

su una versione standard la directoy corretta sarebbe /root

# attenzione il demone crontab si basa sulla directory /etc/crontab.x che non esiste

se volete verificare il comando di riferimento è questo:
<br/>
cat /etc/init.d/crond.sh | grep "crontab.x"
<br/>
su una versione standard la directoy corretta sarebbe /etc/crontabs

# download scritps per la riconnessione internet

mi è stato chiesto di creare 2 script la cui funzione di sottofondo è la riconnessione internet
<br/>

le specifiche dell'utente erano/sono:
<br/>
alle ore 2:00 esegui "script3.sh" e riconnetti internet
<br/>
ogni 2 minuti esegui "script4.sh"
<br/>
in modo tale che se 2 ping verso due host diversi su internet falliscono provi a riconnettersi
<br/>


```
curl -k https://raw.githubusercontent.com/compact21/openwrt-script/refs/heads/main/temp/script3.sh
curl -k https://raw.githubusercontent.com/compact21/openwrt-script/refs/heads/main/temp/script4.sh
```

<br/>
se non funzionano oppure presentano problemi al massimo basta che mi fate sapere
<br/>
qualcosa però il debug dovrete farlo voi sul vostro router
<br/>

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
curl -k https://github.com/compact21/openwrt-script/blob/main/temp/root
```

# riavvio del servizio cron
```
/etc/init.d/crond.sh restart
```
