

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
# cd ~
datos="$HOME/.pi.conf"
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
declare -r NUM_PINGS=10;
# tiempo de espera entre comprobaciones
declare -r TIEMPO_ESPERA=1;
# EDIPLUG_STATUS
declare -r EDIMAX="$(cat $EDIPLUG_ESTADO)";
## ---------------------------------------------------------------------------------------------------------------------

## TEXTOS ##
## ---------------------------------------------------------------------------------------------------------------------
declare -r TXT_EDIMAX_ESTADO="EDIMAX $EDIMAX";
declare -r TXT_EDIMAX_OFF="$HOY_LOG: $TXT_EDIMAX_ESTADO\t KODI OFF\tEXIT";
declare -r TXT_PING_OFF="$HOY_LOG: $TXT_EDIMAX_ESTADO\tKODI OFF";
declare -r TXT_CONEXION_ON="$HOY_LOG: $TXT_EDIMAX_ESTADO\tKODI: ON\tEXIT";
declare -r TXT_KODI_OFF="$HOY_LOG: $TXT_EDIMAX_ESTADO\tKODI OF\tEDIMAX-> OFF";
declare -r TXT_OUT="$HOY_LOG\t"
## --------------------------------------------------------------------------------------------------------------------------

## CÓDIGO ##
## APAGAR SERVIDOR MULTIMEDIA ##
## -------------------------------------------------------------------------------------------------------------------------------------
if [ "$1" == "-r" ] || [ "$1" == "-h" ]; then
printf "$TXT_OUT" | tee -a $LOG_KODISLEEP
ssh pi@$RPI2_MEDIA_IP "sudo shutdown $1 $2" &>> $LOG_KODISLEEP
sleep $TIEMPO_POWEROFF;
printf "\n";	# evita que quede el prompt al lado del último stdout
exit 0;
fi
## ---------------------------------------------------------------------------------------------------------------------

## COMPROBANDO CONEXIÓN CON EDIPLUG ##
## ---------------------------------------------------------------------------------------------------------------------------------------------------
# No lo puedo cargar sin el . delante porque entonces no tiene disponible en ediplug.sh la configuración cargada en kodi.sh
. ediplug.sh
wait $!
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
. ediplug.sh OFF
#python ~/python/ediplug-py/src/ediplug/smartplug.py -H $EDIPLUG_IP -l $EDIPLUG_USUARIO -p $CLAVE_EDIPLUG -s OFF
#printf "$TEXTO $GO\n" | tee -a $LOG_EDIPLUG
