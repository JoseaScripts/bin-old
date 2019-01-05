#!/bin/bash
# respaldos_fdupes.sh
# release v1.0

## USO ##
# Repasa los archivos copiados en /samba/respaldos y elimina los que no han sufrido cambios

## CÓDIGO ##

# Genera la lista de los archivos duplicados
fdupes -rf /samba/respaldos/ > /samba/respaldos/borrar;
# Ordena el registro de duplicados y elimina las líneas en blanco
sort /samba/respaldos/borrar | uniq | grep -v '^$' > /samba/respaldos/borrar_sort;
# Repasa la lista y mueve los archivos duplicados a /samba/copias_fdupes
while read file; do mv -bv "$file" /samba/copias_fdupes/; done < /samba/respaldos/borrar_sort
# Busca directorios vacíos y los elimina
find /samba/respaldos/* -type d -empty -delete
