#!/bin/bash
# ~/bin/router.sh
# Creado el 30/11/2018
# release v1.0

## FUNCIONES ##
# Apagar o reiniciar el equipo si no encuentra la ip del router
# Se puede utilizar en un futuro para apagar un enchufe inteligente done esté conectado el router.

## PARÁMETROS ##
# Si envío un parámetro este pasa a ser la IP donde buscamos el MODEM
# De momento no acepto parámetros para simplificar el programa
# [ "$1" ] && IP_MODEM="$1" && declare -r CONFIGURACION=True;

## INCLUDES ##
# Evita incluir dos veces los scripts de configuración.
# Si hemos encontrado un parámetro '$1' no cargamos el archivo.
if [[ -z $CONFIGURACION ]]; then
  printf "$CONFIGURACION";
  bin_conf="$HOME/bin/config";
  [[ -f $bin_conf ]] && . $bin_conf
  printf "Include: $bin_conf\n";
fi

## VARIABLES Y CONSTANTES ##
# contador
i=0;
# Número de intentos de ping
declare -r NUM_PINGS=10;
# tiempo de espera entre comprobaciones
declare -r TIEMPO_ESPERA=0.2;
# Textos
declare -r TXT_OK_PING="$HOY_LOG\t Conexión:\t PING a $IP_MODEM recibido";
declare -r TXT_NO_PING="$HOY_LOG\t Conexión:\t PING a $IP_MODEM extraviado";
declare -r TXT_APAGADO="Ejecutando shutdown ";

while [ $i -lt $NUM_PINGS ]; do
    # En caso de no poder conectar con el modem apago el equipo
    ping -c 1 $IP_MODEM && printf "$TXT_OK_PING\n" | tee "$LOG_ROUTER" && exit 0 || printf "$TXT_NO_PING\n"
#    wait $!
    sleep $TIEMPO_ESPERA;
    i=$[$i+1];
done

# Después de no conseguir respuesta al ping...
printf "$TXT_NO_PING:\t$TXT_APAGADO -r 5" | tee "$LOG_ROUTER"
sudo shutdown -r 5;
