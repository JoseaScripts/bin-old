#!/bin/bash
# ~/bin/ediplug.sh
# Creado 01 Dic. 2018
# release v1.0

## INCLUDES ##
# Evita incluir dos veces los scripts de configuración.
if [[ -z $CONFIGURACION ]]; then
  printf "$CONFIGURACION";
  config="$HOME/bin/config";
  [[ -f $config ]] && . $config
  printf "Include: $config\n";
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

## PARÁMETROS ##
# $1 = ON/OFF

## VARIABLES Y CONSTANTES ##
# Se carga 2 veces desde kodi.sh por lo que no puede ser una constante
TEXTO="Estado EDIMAX:";

## CÓDIGO ##
## -------------------------------------------------------------------------------------------------------------------
if [ $1 ]; then
  OPCION="-s $1";
  printf "$TEXTO $1\n";
  echo $1 > $LOG_EDIPLUG_ESTADO;
elif [ $VAR_ACCION ]; then
  OPCION="-s $VAR_ACCION";
  printf "$TEXTO accion=$VAR_ACCION\n";
  echo $VAR_ACCION > $LOG_EDIPLUG_ESTADO;
else
  OPCION="-g";
fi

GO=`python ~/python/ediplug-py/src/ediplug/smartplug.py -H $IP_EDIPLUG -l $USUARIO_EDIPLUG -p $CLAVE_EDIPLUG $OPCION`

# $GO solo tiene valor cuando se hace una consulta del estado '-g'
[[ ! -z $GO ]] && printf "$TEXTO $GO\n" && echo $GO > $LOG_EDIPLUG_ESTADO
