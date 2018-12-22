#!/bin/sh
# /home/pi/bin/mega-unrar.sh
# v1.0

# EJECUCIÓN
# Se puede llamar directamente al archivo desde cualquier lugar.
# Tiene una llamada dede el CRONTAB cada 2 horas

# FUNCIONES
# Optimizado para la web: https://www.mega-estrenos.org
# Busca los archivos descargados con mega, los descomprime y los mueve
# a la carpeta /media/descargas/samba donde puedo acceder desde kodi
# Primero comprueba que la sincronización esté finalizada para que los archivos estén completos.

# CÓDIGO OBSOLETO # -------------------------------------------------------
# find /media/descargas/mega -iname '*.rar' -exec 7z e {} \;
# -------------------------------------------------------------------------

# OTRAS ACLARACIONES
# Cadena a buscar en el stdout de 'mega-sync 0' para comprobar que se descargó todo

# CÓDIGO RESIDUAL -------------------------------------------------------------------
synced="Synced";
{
	checksync=$(mega-sync 0 2> /dev/fd/3)
	error=$(cat<&3)
} 3<<EOF
EOF

# Si da error
if [ -n "$error" ];  then
	printf "$error\nError de sincronización.\n";
	exit;
else
	printf "De momento bien\n"
fi

if [ "$checksync" = "*Synced*" ]; then
 printf "FUNCIONA\n$checksync\nSincronización finalizada.\n";
else
 printf "Archivos pendientes de sincronización.\n"
 # exit 0;
fi
# -----------------------------------------------------------------------------------


# CÓDIGO ------------------------------------------------------------------

## VARIABLES O CONSTANTES
. ~/bin/mega-unrar.conf
## VARIABLES O CONSTANTES
# export megasync0="megasync0";
# Este es el directorio donde quiero descomprimir los archivos descargados
# export unrarDir="/media/descargas/samba/mega/";
# Archivos a descomprimir
# export rarFiles="/media/descargas/mega";
#export rarFiles="/media/descargas/mega/josea/*.rar";
# Ruta a descargas
# export rarUrl="/media/descargas/mega";
# Clave para descomprimir archivos
# export rarClave="www.mega-estrenos.com";

#Carpetas de descarga
# unrarDirs="josea fatima Marcos";


mega-sync 0 | tee $megasync0;
wait $!;

while read line; do
  for word in $line; do
    if [ "$word" = "Synced" ]; then
      echo "Sincronización con servidor MEGA finalizada.\n";
      for carpeta in $unrarDirs; do
      printf "Buscando archivos 'rar' en $carpeta\n";
      mega-unrardir.sh $carpeta;
      done
      wait $!;
      rm $megasync0;
      sudo chmod -R 777 $unrarDir;
      exit 0;
    else
      echo ".";
      sleep 0.2;
    fi
  done # for word...
done < $megasync0
