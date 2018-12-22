#!/bin/bash
# ~/bin/kodi.sh
# Creado el 03/12/2018
# v2.0

## FUNCIONES ##
# Apagar el enchufe EDIPLUG cuando falla un ping a la IP del reproductor KODI
# Toma los datos privados del archivo .pi.conf
# Mantiene un registro del estado del enchufe y del servidor multimedia (Raspberry)

## NOVEDADES ##
# He decidido finalmente que todos mis scripts bash finalicen en '.sh' para reconocerlos más facilmente

## MEJORAS PENDIENTES ##
# Simplificar la comprobación del estado del enchufe guardando la salida de 'ediplug.sh'
# Aparece un error al cargar por segunda vez el script 'ediplug.sh' ya que carga dos veces el texto
# Poder enviar un 'kodi.sh ON' y actuar según se reciba PING y según el estado de 'EDIMAX'

## LOG ##
# Se escribe un registro cada vez que se ejecuta el programa
# El archivo de registro cambia con el número de semana y año en un carpeta independiente dentro de ~/logs/

# INCLUDES ##
# Si ejecuto como sudo el archivo lo busca en /root/archivo, por lo que no lo encuentra

# ~/bin/ediplug
#. ~/.pi.conf
cd ~
datos=".pi.conf"
if [ -f "$datos" ]; then
  . $datos
  printf "Configuración: $datos\n";
else
  printf "Configuración: No disponible\n"
  exit 0
fi

## VARIABLES Y CONSTANTES ##
## -------------------------- -------------------------------------------------------------------------------------------
# contador
i=0;
# Espera después de 'poweroff'
declare -r TIEMPO_POWEROFF=35;
# Número de intentos de ping
declare -r NUM_PINGS=6;
# tiempo de espera entre comprobaciones
declare -r TIEMPO_ESPERA=5;
# EDIPLUG_STATUS
declare -r EDIMAX="$(cat $EDIPLUG_ESTADO)";
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
## --------------------------------------------------------------------------------------------------------------------
# Código original
# OUT=`ssh pi@$RPI2_MEDIA_IP "sudo poweroff"`;
# wait $!;
# printf "$HOY_LOG: Orden de apagado enviada a RPI2_MEDIA at $RPI2_MEDIA_IP\n\t$OUT\n" | tee -a $LOG_KODISLEEP
## ---------------------------------------------------------------------------------------------------------------------
if [ "$1" == "-r" ] || [ "$1" == "-h" ]; then
printf "$TXT_OUT" | tee -a $LOG_KODISLEEP
ssh pi@$RPI2_MEDIA_IP "sudo shutdown $1 $2" &>> $LOG_KODISLEEP
# sleep $TIEMPO_POWEROFF;
sleep 5;
exit 0;
fi
## ---------------------------------------------------------------------------------------------------------------------

## COMPROBANDO CONEXIÓN CON EDIPLUG ##
## --------------------------------------------------------------------------------------------------------------------
# Este código podría funcionar si la salida no tuviera texto incorporado:
# [[ "$(ediplug.sh)" == "OFF" ]] && exit 0;
# Puedo llamar al script sin el punto pero en no se exporta la configuración y tengo que cargarla en 'ediplug.sh'
# ediplug
# Si lo llamo con el punto '. ediplug.sh' se exporta la configuración ya cargada en este script

. ediplug.sh
wait $!;

# Compruego el estado del enchufe con el registro 'logs/EDIPLUG_STATUS'
# En caso de estar apagado imprimo el registro y salgo del programa
[[ $(cat $EDIPLUG_ESTADO) == "OFF" ]] && printf "$TXT_EDIMAX_OFF\n" | tee -a $LOG_KODIOFF && exit 0;
## ---------------------------------------------------------------------------------------------------------------------

## COMPROBANDO CONEXIÓN DE KODI ##
## ---------------------------------------------------------------------------------------------------------------------
while [ $i -lt $NUM_PINGS ]; do
    # En caso de no poder conectar con kodi apago el enchufe de la rpi y de los discos duros externos
    sleep $TIEMPO_ESPERA;
    ping -c 1 $RPI2_MEDIA_IP >> /dev/null && printf "$TXT_CONEXION_ON\n" | tee -a "$LOG_KODIOFF" && exit 0 || printf "$TXT_PING_OFF\n"
    i=$[$i+1];
done

# Después de no conseguir respuesta al ping:
# Escribo en el log...
printf "$TXT_KODI_OFF\n" | tee -a "$LOG_KODIOFF";

## APAGO EL ENCHUFE ##
# ediplug.sh OFF;		# funciona desde la terminal, pero no funciona desde el crontab
# OUT="$(ediplug.sh OFF)";	# funciona desde la terminal, pero no funciona desde el cron
# ediplug.sh "OFF";	# funciona desde la terminal, pero no funciona desde el cron
# OUT=`ediplug.sh OFF`;	# funciona desde la terminal, pero no funciona desde el crontab

# Ahora, con el punto delante si funciona
# El problema es que me cargaba dos veces la configuración y me aparecían mensajes de error
# por intentar modificar las constantes del archivo de configuración al llamarlo de nuevo.
# Lo arreglé con un if en 'bin/ediplug.sh'
# Ahora lo que carga por duplicado son las constantes de 'ediplug.sh' -> "$TXT_OUT"
#. ediplug.sh OFF
# Exportando el valof 'OFF' para apagar ediplug, tampoco funciona desde el crontab, aunque si directamente de la terminal
# export VAR_ACCION="OFF"
# . ediplug.sh
# Tampoco funciona con eval
# GO="ediplug.py OFF"
# eval $GO
python ~/python/ediplug-py/src/ediplug/smartplug.py -H $EDIPLUG_IP -l $EDIPLUG_USUARIO -p $EDIPLUG_CLAVE -s OFF
printf OFF > $EDIPLUG_ESTADO;
