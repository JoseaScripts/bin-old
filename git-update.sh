#!/bin/sh
# /home/pi/bin/git-update.sh
# v1.6

## FUNCION ##
# Pasando como parámetro el texto para el commit actualiza el repositorio actual
# Tambien paso como parámetro la rama donde actualizar el código
# Ahora envía usuario y clave

## PENDIENTE ##
# enviar con usuario y clave desde el archivo de configuración
# Se hace con el comando git push -u https://USUARIO:CLAVE@github.com/RpiScripts/bin master
# El problema es que si lo escribo en el script estoy dando la clave a mi cuenta de github
# Y que de momento me da un error al intentar leer el usuario y la clave de ~/.pi.conf

## EJEMPLO ##
# git-update.sh "v1.2" "version2"
# Ahora, para evitar errores directamente actualiza la RAMA -> Extensa

excluir=""

cd $HOME/bin;

git add --all
git add .
for f in .config .nuevo .privado .privado.json privado.sh bin.config privado.sh
do
  git rm $f;
  printf "$f\n";
done;

git commit -m "$1"
git push -u https://JoseaScripts@github.com/JoseaScripts/bin "Extensa"
