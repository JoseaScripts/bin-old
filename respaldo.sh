#!/bin/bash
# respaldo.sh
# release v1.0

## USO ##
# Crea un respaldo del 'home' del usuario

## CÓDIGO ##

# VARIABLES Y CONSTANTES
# fecha del respaldo
declare -r NOMBRE_RESPALDO=$(date +%Y%m%d_%H%M%S);

# FUNCIÓN DE LA COPIA DE SEGURIDAD
tar -zcvf /samba/respaldos/$USER-HOME-$NOMBRE_RESPALDO.tar.gz $HOME/
