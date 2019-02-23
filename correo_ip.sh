#!/bin/bash
# ~/bin/correo_ip.sh
# release v1.1

. $HOME/bin/.usuarios.conf

ip=`cat /home/pi/logs/IP_LOG`;

echo "To: $CUENTA_CORREO_DOMO
From: rpi2-servidor
Subject: Direcciones IP

Correo enviado mediante script propio:
~/bin/correo_ip.sh v1.1

torrents: http://$ip:$PUERTO_TRANSMISSION
camara:	  http://$ip:$PUERTO_MOTIONEYE
ssh: 	  ssh://pi@$ip:$PUERTO_SSH"> $HOME/includes/correo_ip.txt

wait $!

cat $HOME/includes/correo_ip.txt | /usr/sbin/sendmail $CUENTA_CORREO_ENVIO
