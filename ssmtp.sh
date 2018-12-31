#!/bin/bash

sed -i 's/^mailhub=.*/mailhub=smtp.gmail.com:587/g' /etc/ssmtp/ssmtp.conf
sed -i 's/^#FromLineOverride=YES/FromLineOverride=YES/g' /etc/ssmtp/ssmtp.conf
sudo echo "[GMAIL]
AuthUser=$1@gmail.com
AuthPass=$2
UseSTARTTLS=YES">> /etc/ssmtp/ssmtp.conf
