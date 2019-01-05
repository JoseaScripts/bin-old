#!/bin/bash
# ~/bin/mega-unrardir.sh
# release v1.0

# EJECUCIÓN
# Este script se llama desde mega-unrar.sh
# Se puede ejecutar directamente con la opción del directorio donde se quiere buscar los archivos:
# EJEMPLO:
# mega-unrardir.sh josea

# FUNCIONES
# Descomprime los archivos descargados desde la web https://www.mega-estrenos.org
# Se encarga de la contraseña para la descompresión.
# También mueve los archivos descomprimidos y el original a un directorio accesible por NFS desde Kodi

## CÓDIGO ##

## INCLUDES
# Evita incluir dos veces los scripts de configuración.
if [[ -z $rarFiles ]]; then
  datos="$HOME/bin/mega-unrar.conf";
  [[ -f $datos ]] && . $datos
  printf "Include: $datos\n";
else
  printf "Include cargado anteriormente: $datos\n"
fi


# SELECCIONO LOS DIRECTORIOS DONDE BUSCARÉ LOS ARCHIVOS COMPRIMIDOS DESCARGADOS ------------------------------
# Estas líneas me permiten buscar archivos 'rar' en distintos directorios listados en el archivo de configuración
for rardirs in $1; do
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
		exit 0;
            fi
# --------------------------------------------------------------------------------------------------------

	    printf "Tareas finalizadas en ../$1/.\n"
	  else
	    printf "No se encontraron archivos en $rarFiles/$rardirs/\n";
	  fi # if -e rar

        done # for rar in...

done 
