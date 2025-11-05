#!/bin/bash
#==================================================================
# Script: contarFicheros.sh
# Descripcion: Cuenta el número de archivos en un directorio
# autor: Asier Rodriguez
# Creacion: 2024-06-27
# Comentarios: Ejemplo de como contar ficheros en un directorio dado
#==================================================================
# Si se proporciona un directorio como argumento, usarlo; si no, usar el directorio actual
if [ $# -eq 1 ]; then
    Ruta="$1"
else
    Ruta="."
fi

# Verificar si el directorio existe
if [ ! -d "$Ruta" ]; then
    echo "Error: El directorio $Ruta no existe"
    exit 1
fi

echo "Directorio a analizar: $Ruta"
echo "Número de ficheros en el directorio:"
ls -l "$Ruta" | wc -l