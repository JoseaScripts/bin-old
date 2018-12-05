#!/bin/bash
# ~/bin/router.sh
# Creado el 30/11/2018
# 1.0

## FUNCIONES ##
# Apagar o reiniciar el equipo si no encuentra la ip del router
# Se puede utilizar en un futuro para apagar un enchufe inteligente done esté conectado el router.

# INCLUDES ##
# Si ejecuto como sudo el archivo lo busca en /root/.pi.conf, por lo que no lo encuentra
#. ~/.pi.conf
datos="/home/pi/.pi.conf"
[ -f "$datos" ] && . $datos
[ ! -f "$datos" ] && [ -z "$1" ] && MODEM_IP="$1"

## VARIABLES Y CONSTANTES ##
# contador
i=0;
# Número de intentos de ping
declare -r NUM_PINGS=10;
# tiempo de espera entre comprobaciones
declare -r TIEMPO_ESPERA=1;
# Ruta de los logs
declare -r LOG_ROUTER="/home/pi/logs/router/$HOY_ANYO-$HOY_SEMANA.log";
# Textos
declare -r TXT_OK_PING="$HOY_LOG\t Conexión:\t PING a $MODEM_IP recibido";
declare -r TXT_NO_PING="$HOY_LOG\t Conexión:\t PING a $MODEM_IP extraviado";
declare -r TXT_APAGADO="Ejecutando shutdown ";

while [ $i -lt $NUM_PINGS ]; do
    # En caso de no poder conectar con el modem apago el equipo
    #sleep $TIEMPO_ESPERA;
    ping -c 1 $MODEM_IP && printf "$TXT_OK_PING\n">>"$LOG_ROUTER" && exit 0 || printf "$TXT_NO_PING\n"
    wait $!
    i=$[$i+1];
done

# Después de no conseguir respuesta al ping...
if [ "$1" == "-r" ]] || [ "$1" == "-h" ]; then
printf "$TXT_NO_PING:\t$TXT_APAGADO $1 $2">>"$LOG_ROUTER"
sudo shutdown $1 $2;
else
  sudo shutdown -r 5;
fi
