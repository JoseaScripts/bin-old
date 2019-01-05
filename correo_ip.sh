#!/bin/bash
# ~/bin/correo_ip.sh
# release v1.0

ip=`cat /home/pi/logs/IP_LOG`;

echo "To: $CUENTA_CORREO_DOMO
From: rpi2-servidor
Subject: Direcciones IP

torrents: http://$ip:$PUERTO_TRANSMISSION
camara:	  http://$ip:$PUERTO_MOTIONEYE
ssh: 	  pi@$ip:$PUERTO_SSH"> $HOME/bin/correo_ip.txt

wait $!

cat $HOME/mail.txt | /usr/sbin/sendmail $CUENTA_CORREO_ENVIO
