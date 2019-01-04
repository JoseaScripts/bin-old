#!/bin/sh
# /home/pi/bin/git-update.sh
# release v1.0

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

## INCLUDES ##
# Evita incluir dos veces los scripts de configuración.
if [[ -z $CONFIGURACION ]]; then
  printf "$CONFIGURACION";
  bin_conf="$HOME/bin/bin.conf";
  [[ -f $bin_conf ]] && . $bin_conf
  printf "Include: $bin_conf\n";
fi
if [[ -z $USUARIOS ]]; then
  printf "$USUARIOS";
  usuarios_conf="$HOME/bin/.usuarios.conf";
  [[ -f $usuarios_conf ]] && . $usuarios_conf
  printf "Include: $usuarios_conf\n";
fi
if [[ -z $CLAVES ]]; then
  printf "$CLAVES";
  claves_conf="$HOME/bin/.claves.conf";
  [[ -f $claves_conf ]] && . $claves_conf
  printf "Include: $claves_conf\n";
fi


printf "
USUARIO_GIT: $USUARIO_GIT
CLAVE_GIT: $CLAVE_GIT
";

cd $HOME/bin;

for f in $(ls);
do
  git add $f;
  printf "$f\n";
done;
# git add --all
# git add .
git commit -m "$1"
# git rm bin.config
git push -u https://$USUARIO_GIT:$CLAVE_GIT@github.com/JoseaScripts/bin "$2"
