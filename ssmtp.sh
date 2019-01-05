#!/bin/bash
# ~/bin/ssmtp.sh
# release v1.0

## USO ##
# Configura el programa ssmtp para utilizar una cuenta de gmail

# PARÁMETROS
# $1 -> nombre de usuario de gmail
# $2 -> clave de la cuenta de gmail
# EJEMPLO: ssmtp.sh USUARIO_GMAIL CLAVE_GMAIL

# Añado el servidor de gmail en 'mailhub='
sed -i 's/^mailhub=.*/mailhub=smtp.gmail.com:587/g' /etc/ssmtp/ssmtp.conf
# Saco el comentario '#' de la línea FromLineOverride
sed -i 's/^#FromLineOverride=YES/FromLineOverride=YES/g' /etc/ssmtp/ssmtp.conf
# Añado la cuenta de usuario de gmail
sudo echo "[GMAIL]
AuthUser=$1@gmail.com
AuthPass=$2
UseSTARTTLS=YES">> /etc/ssmtp/ssmtp.conf
