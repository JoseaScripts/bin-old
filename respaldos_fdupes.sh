#!/bin/bash
# respaldos_fdupes.sh

fdupes -rf /samba/respaldos/ > /samba/respaldos/borrar; sort /samba/respaldos/borrar | uniq | grep -v '^$' > /samba/respaldos/borrar_sort;
while read file; do mv -bv "$file" /samba/copias_fdupes/; done < /samba/respaldos/borrar_sort
find /samba/respaldos/* -type d -empty -delete
