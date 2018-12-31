#!/bin/bash

ip=`cat /home/pi/logs/IP_LOG`;

echo "To: ENCAPY@gmail.com
From: servidor@gmail.com
Subject: Prueba de correo\n

transmision:	http://$ip:9091
motionEye	http://$ip:80
servidor:	pi@$ip:2022"> test.txt

wait $!

cat $HOME/test.txt | sendmail grupoeuroga@gmail.com
