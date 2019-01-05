#!/bin/bash
# ~/bin/mega-unrar.sh
# release v1.0

# EJECUCIÓN
# Se puede llamar directamente al archivo desde cualquier lugar.
# Tiene una llamada dede el CRONTAB

# FUNCIONES
# Optimizado para la web: https://www.mega-estrenos.org
# Busca los archivos descargados con mega, los descomprime y los mueve
# a la carpeta /media/descargas/samba donde puedo acceder desde kodi
# Primero comprueba que la sincronización esté finalizada para que los archivos estén completos.

# CÓDIGO OBSOLETO PARA OTRO SCRIPT MAS SIMPLE # -------------------------------------------------------
# find /media/descargas/mega -iname '*.rar' -exec 7z e {} \;
# -------------------------------------------------------------------------

# CÓDIGO  -------------------------------------------------------------------

## VARIABLES O CONSTANTES
. $HOME/bin/mega-unrar.conf;

# Muestro fecha y hora para que quede constancia en el log
printf "TAREA INICIADA HOY: $HOY_LOG\n";

# Compruebo si hay un error en la salida del comando mega-sync 0
# Código sacado de internet, no lo entiendo del todo.
# https://unix.stackexchange.com/questions/474177/how-to-redirect-stderr-in-a-variable-but-keep-stdout-in-the-console
{
    checksync=$(mega-sync 0 2> /dev/fd/3)
    res=$?; # normalmente la salida de este comando es 0
    error=$(cat<&3)
} 3<<EOF
EOF

# Si da error...
if [ -n "$error" ];  then
	printf "$error\nError de sincronización.\n";
	exit 0;
else
	printf "Comprobación de sincronicación: Sin Errores\n"
fi
# -----------------------------------------------------------------------------------

# Compruebo si finalizó la sincronización
estado_sync=`echo "$checksync" | cut -d" " -f10`

    if [[ "$estado_sync" =~ "$synced" ]]; then
	for carpeta in $unrarDirs; do
	  . $HOME/bin/mega-unrardir.sh $carpeta
	  wait $!;
	  sudo chmod -R 777 $unrarDir
	done
    else
	printf "Sincronización en curso. No se puede ejecutar el programa.\n"
    fi
