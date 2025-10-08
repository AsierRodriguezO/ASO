<#
    .SYNOPSIS
         [Un array que contiene nombres de personas y los muestra en pantalla.]

    .DESCRIPTION
         [Primer ejercicio que creo en PowerShell para mostrar un array de nombres.]

    .PARAMETER 
        [No hay parámetros en este script simple.]
    .EXAMPLE

    .NOTES
        Autor: Asier
        Fecha: 29/09/2025
        Versión: 1.0
        Notas: []
#>
$Array= @()
$Array+= "Luis","Pedro","Maria"
$numeros =(1..6)  
$Ruta= "$env:USERPROFILE\Desktop\Script"
$CRuta= (Get-ChildItem -Path $Ruta )

write-host "Este es el array completo: $Array"
write-host "Muestro el ultimo elemento del array: $($Array[-1])"
Write-Host "Muestro los numeros del array: $numeros"
Write-Host "Muestro el contenido de la carpeta: $CRuta"
write-host "Muestro la cantidad de ficheros: $($CRuta.count)"
