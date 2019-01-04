#!/bin/bash

ip=`cat /home/pi/logs/IP_LOG`;

echo "To: josea.parana@gmail.com
From: servidor@gmail.com
Subject: Direcciones IP de rpi2-servidor

torrents: http://$ip:9091
camara:	  http://$ip:80
ssh: 	  pi@$ip:2022"> $HOME/mail.txt

wait $!

cat $HOME/mail.txt | /usr/sbin/sendmail grupoeuroga@gmail.com
