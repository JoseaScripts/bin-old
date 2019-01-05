#!/bin/bash
# /home/pi/bin/git-update.sh
# release v1.0

## FUNCION ##
# Pasando como parámetro el texto para el commit actualiza el repositorio actual
# Tambien paso como parámetro la rama donde actualizar el código
# Ahora envía usuario y clave

## PENDIENTE ##
# Añadir commit y rama (branch) por defecto.

## EJEMPLO ##
# git-update.sh "v1.2" "version2"

## INCLUDES ##
# Evita incluir dos veces los scripts de configuración.
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

cd $HOME/bin;

# No sube los archivos ocultos de configuración:
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
