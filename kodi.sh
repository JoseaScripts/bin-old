#!/bin/bash
# ~/bin/kodi.sh
# Creado el 03/12/2018
# release v1.0

## FUNCIONES ##
# Apagar el enchufe EDIPLUG cuando falla un ping a la IP del reproductor KODI
# Toma los datos privados de los archivos bin/.usuarios.conf y bin/.claves.conf
# Mantiene un registro del estado del enchufe y del servidor multimedia (Raspberry)

## NOVEDADES ##
# He decidido finalmente que todos mis scripts bash finalicen en '.sh' para reconocerlos más facilmente

## MEJORAS PENDIENTES ##
# Poder enviar un 'kodi.sh ON' y actuar según se reciba PING y según el estado de 'EDIMAX'

## LOG ##
# Se escribe un registro cada vez que se ejecuta el programa
# El archivo de registro cambia con el número de semana y año en un carpeta independiente dentro de ~/logs/

# INCLUDES ##
# Evita incluir dos veces los scripts de configuración.
if [[ -z $CONFIGURACION ]]; then
  printf "$CONFIGURACION";
  config="$HOME/bin/config";
  [[ -f $config ]] && . $config
  printf "Include: $config\n";
fi

## VARIABLES Y CONSTANTES ##
## -------------------------- -------------------------------------------------------------------------------------------
# contador
i=0;
# Espera después de 'poweroff'
declare -r TIEMPO_POWEROFF=35;
# Número de intentos de ping
declare -r NUM_PINGS=10;
# tiempo de espera entre comprobaciones
declare -r TIEMPO_ESPERA=0.2;
# EDIPLUG_STATUS
declare -r EDIMAX="$(cat $LOG_EDIPLUG_ESTADO)";
## ---------------------------------------------------------------------------------------------------------------------

## TEXTOS ##
## ---------------------------------------------------------------------------------------------------------------------
declare -r TXT_EDIMAX_ESTADO="EDIMAX $EDIMAX";
declare -r TXT_EDIMAX_OFF="$HOY_LOG: $TXT_EDIMAX_ESTADO\t KODI apagado.\tNo continúo con el programa";
declare -r TXT_PING_OFF="$HOY_LOG: $TXT_EDIMAX_ESTADO\t PING perdido.";
declare -r TXT_CONEXION_ON="$HOY_LOG: $TXT_EDIMAX_ESTADO\t KODI encendido.\t No continúo con el programa";
declare -r TXT_KODI_OFF="$HOY_LOG: $TXT_EDIMAX_ESTADO\t KODI sin respuesta.\t Apagando EDIMAX.";
declare -r TXT_OUT="$HOY_LOG\t Orden de apagado enviada a RPI2_MEDIA.\t\n"
## --------------------------------------------------------------------------------------------------------------------------

## CÓDIGO ##

## APAGAR SERVIDOR MULTIMEDIA ##
if [ "$1" == "-r" ] || [ "$1" == "-h" ]; then
printf "$TXT_OUT" | tee -a $LOG_KODISLEEP
ssh pi@$IP_RPI2_MEDIA "sudo shutdown $1 $2" &>> $LOG_KODISLEEP
# sleep $TIEMPO_POWEROFF;
wait $!;
exit 0;
fi
## ---------------------------------------------------------------------------------------------------------------------

## COMPROBANDO CONEXIÓN CON EDIPLUG ##
. $HOME/bin/ediplug.sh
wait $!;

# Compruego el estado del enchufe con el registro 'logs/EDIPLUG_STATUS'
# En caso de estar apagado imprimo el registro y salgo del programa
[[ $(cat $LOG_EDIPLUG_ESTADO) == "OFF" ]] && printf "$TXT_EDIMAX_OFF\n" | tee -a $LOG_KODIOFF && exit 0;
## ---------------------------------------------------------------------------------------------------------------------

## COMPROBANDO CONEXIÓN DE KODI ##
## ---------------------------------------------------------------------------------------------------------------------
while [ $i -lt $NUM_PINGS ]; do
    # En caso de no poder conectar con kodi apago el enchufe de la rpi y de los discos duros externos
    sleep $TIEMPO_ESPERA;
    ping -c 1 $IP_RPI2_MEDIA >> /dev/null && printf "$TXT_CONEXION_ON\n" | tee -a "$LOG_KODIOFF" && exit 0 || printf "$TXT_PING_OFF\n"
    i=$[$i+1];
done


## APAGO EL ENCHUFE Y ESCRIBO EN EL LOG ##
. $HOME/bin/ediplug.sh OFF && printf "$TXT_KODI_OFF\n" | tee -a "$LOG_KODIOFF";
