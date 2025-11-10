README — PowerShell-PC-Inventory (resumen rápido)

Parámetros implementados

- OutputPath (string)
  - Ruta donde se guarda el inventario y la carpeta de salida.
  - Valor por defecto: %USERPROFILE%\Documents\Inventory (se construye con Join-Path).

- LogPath (string)
  - Ruta donde se guardarán los logs.
  - Valor por defecto: %USERPROFILE%\Documents\Inventory\Logs

- SessionCode (string)
  - Código o iniciales del alumno/operador que se añade a cada línea del log. Por defecto "ARO".

- Concatenate (switch)
  - Si se pasa este switch se ejecuta el modo de concatenación de todos los CSV de inventario en un único informe.

Qué ocurre si no hay red (o no se puede escribir en la ruta de red)

- El script prueba primero si tiene acceso de escritura a la ruta de salida configurada (función Test-WriteAccess).
- Si la ruta de red o compartida no es accesible o no es escribible, el script cambia automáticamente la ruta de salida a la carpeta local del usuario (Documents) como fallback.
- Además, se registra un mensaje WARN en el fichero de logs indicando que se cambió la ruta de salida y el motivo.

Dónde se guarda el inventario

- Inventario por equipo (archivo CSV):
  - <OutputPath>\InventoryOutput\<NombreEquipo>-Inventory.csv
  - Ejemplo con valores por defecto: %USERPROFILE%\Documents\Inventory\InventoryOutput\MI-PC-Inventory.csv

- Log de errores/actividad:
  - <LogPath>\PowerShell-PC-Inventory-Error-Log.log
  - Si no se puede escribir en <LogPath>, el script intentará escribir en: %USERPROFILE%\Documents\PowerShell-PC-Inventory.log

Cómo ejecutar el script (ejemplos)

- Ejecución por defecto (usa rutas por defecto en Documents):

  powershell -ExecutionPolicy Bypass -File .\PowerShell-PC-Inventory.ps1

- Especificando rutas y código de sesión:

  powershell -ExecutionPolicy Bypass -File .\PowerShell-PC-Inventory.ps1 -OutputPath "D:\Inventario" -LogPath "D:\Logs" -SessionCode "ABC"

- Para concatenar todos los CSV de inventario (modo informe):

  powershell -ExecutionPolicy Bypass -File .\PowerShell-PC-Inventory.ps1 -Concatenate

Qué mejoras se han implementado

1. Control y validación de parámetros
   - Parámetros claros: `OutputPath`, `LogPath`, `SessionCode` y `Concatenate`.
   - Valores por defecto seguros basados en %USERPROFILE% (Documents).

2. Sistema de logs centralizado
   - Función `Write-Log` que escribe líneas en el formato:
     [AAAA-MM-DD HH:MM:SS] <NIVEL> <EQUIPO> <SessionCode> Mensaje
   - Niveles soportados: INFO, WARN, ERROR.
   - Fallback a la carpeta Documents si no es posible escribir en la ruta de logs.

3. Prueba de acceso de escritura
   - Función `Test-WriteAccess` que crea un fichero temporal en la ruta de salida para verificar permisos de escritura y lo borra después.
   - Si falla, cambia la salida a Documents y lo anota en el log.

4. Manejo silencioso de errores en terminal
   - Las preferencias de error/progreso se han configurado para que no aparezcan errores en la consola (se registran en el log en su lugar).
   - Evita visual clutter en la ejecución automatizada.

5. Robustez en creación de rutas
   - Uso de `Join-Path` y funciones de comprobación/creación de directorios para asegurar que las carpetas necesarias existen (y fallback si no se pueden crear).

6. Mejoras en la concatenación de CSVs
   - `ConcatenateInventory` acepta un directorio origen (o usa la carpeta de inventario por defecto), procesa CSVs, elimina duplicados y exporta un informe con sello de tiempo.
   - Registra progreso y errores en el log en lugar de imprimir en consola.

Notas y recomendaciones

- Ejecutar con privilegios suficientes si las rutas apuntan a recursos de red que requieran credenciales (p. ej. unidades de red compartidas).
- Si desea ver la salida en tiempo real mientras prueba, puede temporalmente ajustar `$ErrorActionPreference` y mostrar Write-Log también por pantalla (actualmente el script está configurado para registrar en archivos y ser silencioso en terminal).
- Antes de desplegar en un entorno con muchas máquinas, pruebe el script en una o dos máquinas para validar permisos y rutas compartidas.

Si quieres, puedo:
- Añadir un README adicional con instrucciones para desplegar en red (mapear unidades y permisos).
- Añadir ejemplos de pruebas unitarias o un pequeño script de comprobación para validar permisos en lote.
