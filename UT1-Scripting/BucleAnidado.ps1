<#
    .SYNOPSIS
         [Creacion de bucles.]

    .DESCRIPTION
         [Primer script que creo en PowerShell para mostrar bucles.]

    .PARAMETER 
        [No hay parámetros en este script simple.]
    .EXAMPLE

    .NOTES
        Autor: Asier
        Fecha: 01/10/2025
        Versión: 1.0
        Notas: []
#>
$array = @(1,2,3)
# Rellenar tabla 3x3 con 1..9 usando bucles anidados
$rows = 3
$cols = 3

$table = @()
$counter = 1
for ($i = 0; $i -lt $rows; $i++) {
    $row = @()
    for ($j = 0; $j -lt $cols; $j++) {
        $row += $counter
        $counter++
    }
    # Añadimos la fila como elemento (coma para mantener matriz anidada)
    $table += ,$row
}

# Crear tabla inversa 3x3 con 9..1
$revTable = @()
$counter = 9
for ($r = 0; $r -lt $rows; $r++) {
    $row = @()
    for ($c = 0; $c -lt $cols; $c++) {
        $row += $counter
        $counter--
    }
    $revTable += ,$row
}
# Salida modificada: números juntos y tablas seguidas
Write-Host "Tabla 3x3 (1..9):"
foreach ($row in $table) {
    # Unir sin separador para que los números salgan juntos (ej. 123)
    Write-Host ($row )
}
# tabla inversa
foreach ($row in $revTable) {
    Write-Host ($row )
}