#==================================================================
# Script: contarFicheros.sh
# Descripcion: Cuenta el número de archivos en un directorio
# autor: Asier Rodriguez
# Creacion: 2024-06-27
# Comentarios: Ejemplo de como contar ficheros en un directorio dado
#==================================================================

DIRECTORIO=$1
if [ -z "$DIRECTORIO" ]; then
  echo "Uso: $0 <directorio>"
  exit 1
fi

NUM_FICHEROS=$(find "$DIRECTORIO" -type f | wc -l)
echo "El directorio '$DIRECTORIO' contiene $NUM_FICHEROS archivos."
