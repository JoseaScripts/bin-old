#!/bin/sh
# /home/pi/bin/mega-unrardir.sh
# v1.0

# EJECUCIÓN
# Este script se llama desde mega-unrar.sh o se puede ejecutar directamente con la opción del directorio donde se quiere buscar los archivos:
# EJEMPLO:
# mega-unrar-dir.sh josea

# FUNCIONES
# Descomprime los archivos descargados desde la web https://www.mega-estrenos.org
# Se encarga de la contraseña para la descompresión.
# También mueve los archivos descomprimidos y el original a un directorio accesible por NFS desde Kodi

# CÓDIGO
# Recupero las variables del archivo de configuración
. ~/bin/mega-unrar.conf

# SELECCIONO LOS DIRECTORIOS DONDE BUSCARÉ LOS ARCHIVOS COMPRIMIDOS DESCARGADOS ---------------------------------------------------
# Esta línea me permite buscar archivos 'rar' en distintos directorios listados en el archivo de configuración
# También me permite hacer un barrido en busca de archivos 'rar' en uno de los directorios dentro de /media/descargas/mega/
for carpeta in $unrarDirs; do
  printf "Buscando archivos 'rar' en $carpeta\n";

for rardirs in $unrarDirs; do
        for rar in $rarFiles/$rardirs/*.rar; do
	  if [ -e  "$rar" ]; then
	    printf "Hay archivos 'rar en $rarFiles/$rardirs/\n";
            printf "Descomprimiendo $rar.\n";
# ---------------------------------------------------------------------------------------------------------------------------------

# DESCOMPRIMO LOS ARCHIVOS .RAR ----------------------------------------------------------------------------------------------------
            # Codigo extraido de:
            # https://unix.stackexchange.com/questions/430161/redirect-stderr-and-stdout-to-different-variables-without-temporary-files
{
        out=$(7z x -y -o${unrarDir} -p${rarClave} ${rar} 2> /dev/fd/3)
        err=$(cat<&3)
} 3<<EOF
EOF
# -----------------------------------------------------------------------------------------------------------------------------------

# BUSCO ERRORES AL DESCOMPRIMIR ------------------------------------------------------------------------
            # Si no hay errores:
            if [ -z "$err" ]; then
                printf "$out\n";
                mv -vb $rar $unrarDir;
	    # Esta parte parece no funcionar
	    # Cuando se detecta un error al descomprimir no detiene el script.
            else
                printf "err0r: $err\n":
#		exit;
            fi
# --------------------------------------------------------------------------------------------------------

	    printf "Tareas finalizadas en ../$1/.\n"
	  else
	    printf "No se encontraron archivos en $rarFiles/$rardirs/\n";
	  fi # if -e rar

        done # for rar in...

done

done

