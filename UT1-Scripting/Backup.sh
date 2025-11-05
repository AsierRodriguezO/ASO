#!/bin/bash
#==================================================================
# Script: backup.sh
# Descripcion: Realiza una copia de seguridad de un directorio
# autor: Asier Rodriguez
# Creacion: 2024-06-27
# Comentarios: Ejemplo de como realizar una copia de seguridad
#==================================================================
# Si se proporcionan dos argumentos (origen y destino), usarlos; si no, usar valores por defecto
if [ $# -eq 2 ]; then
    Origen="$1"
    Destino="$2"
else
    Origen="."
    Destino="$HOME/backup"
fi

# Verificar si el directorio de origen existe
if [ ! -d "$Origen" ]; then
    echo "Error: El directorio de origen $Origen no existe"
    exit 1
fi
# Crear el directorio de destino si no existe
mkdir -p "$Destino"
# Realizar la copia de seguridad
cp -r "$Origen" "$Destino"
echo "Copia de seguridad de $Origen realizada en $Destino"

