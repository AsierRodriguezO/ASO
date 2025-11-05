#==================================================================
# Script: Saludo.ps1    
# Descripcion: Saluda al usuario cuyo nombre se pasa como parametro
# autor: Asier Rodriguez
# Creacion: 2024-06-27
# Comentarios: Ejemplo basico de uso de parametros en un script de Bash
#==================================================================
if [ $# -eq 0 ]
then
  echo "No se reciben parametros"
  exit 1
fi
NOMBRE=$1
echo "Hola $NOMBRE"