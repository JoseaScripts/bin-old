#!/bin/bash
# respaldo.sh

# fecha del respaldo
declare -r NOMBRE_RESPALDO=$(date +%Y%m%d_%H%M%S);

tar -zcvf /samba/respaldos/pi_bk_$NOMBRE_RESPALDO.tar.gz $HOME/
