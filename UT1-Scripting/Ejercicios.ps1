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
#Numero es par o impar

Write-Host "Ejercicio 1.1"

    $numero= Read-Host -Prompt "Dame un numero y te dire si es par o impar"
        if ($numero % 2 -eq 0){
            write-host "El numero $numero es par"
        }else{
            write-host "El numero $numero es impar"
        }
Write-Host "-----------------------------------"
#Mayor o menor de edad
Write-Host "Ejercicio 1.1"
        [int]$edad= Read-Host -Prompt "Dime tu edad"
        if($edad -le 18){
            Write-Host "Eres menor de edad"
        }else{
            Write-Host "Eres mayor de edad"
        }
Write-Host "-----------------------------------"
#Bucles
Write-Host "Ejercicio 2.1"
#Tablas de multiplicar
   [int]$tabla= Read-Host -Prompt "Dame un numero y creare su tabla de multiplicar"
    for ($i=1; $i -le 10;$i++)
    {
        Write-Host "$tabla x $i = $($tabla*$i)"
        
    }
Write-Host "-----------------------------------"
#Sumea de numeros
Write-Host "Ejercicio 2.2"
    $suma=0
        for($i=1; $i -le 100; $i ++){
            $suma=$suma+$i           
    }
    Write-Host "La suma total es: $suma"
Write-Host "-----------------------------------"
#Pinta-array
Write-Host "Ejercicio 3"
    $Nombres= @("Luis","Pedro","Maria","Ana","Sergio")
        foreach($resultado in $Nombres){
            Write-Host "Hola:"$resultado
        }
Write-Host "-----------------------------------"
#Calcula Array
Write-Host "Ejercicio 3.2"
    $Acalcula= @(1..10)
        foreach($nume in $Acalcula){
            $cuadrado= $nume * $nume
            Write-Host "El cuadrado de $nume es: $cuadrado"
        }
Write-Host "-----------------------------------"
#Muestra menu
Write-Host "Ejercicio 4.1"
        Write-Host "Menu de opciones"
        Write-Host "1. Mostrar fecha actual"
        Write-Host "2. Mostrar el usuario actual"
        Write-Host "3. salir" 
        $opcion= Read-Host -Prompt "Eligeuna opcion"
        switch ($opcion) {
            1 {Write-Host "La fecha actual es: $(Get-Date)"; break;}
            2 {Write-Host "El usuario actual es: $env:USERNAME"; break;}
            3 {Write-Host "Saliendo del menu ..."; exit}
            Default {Write-Host "Valor no valido"; break;}
        }
Write-Host "-----------------------------------"

#Calcula nota
Write-Host "Ejercicio 4.2"
        [int]$Cnotar= Read-Host -Prompt "Dime cual es tu nota"
        switch ($Cnotar) {
            {($Cnotar -ge 0) -and($Cnotar -lt 5)} {Write-Host "Suspenso"; break;}
            {($Cnotar -ge 5) -and($Cnotar -lt 7)} {Write-Host "Aprobado"; break;}
            {($Cnotar -ge 7) -and($Cnotar -lt 9)} {Write-Host "Notable"; break;}
            {($Cnotar -ge 9) -and($Cnotar -le 10)} {Write-Host "Sobresaliente"; break;}
            Default {Write-Host "Esta nota no puede ser calificada"; break;}
        }
        
Write-Host "-----------------------------------"
Write-Host "Ejercicio 5.1"

    $numeroP= Read-Host -Prompt "Dame un numero y te dire si es par o impar"
        if ($numeroP % 2 -eq 0){
            write-host "El numero $numero es par"
            mkdir "C:\Users\Server\Desktop\Pares"
        }else{
            write-host "El numero $numero es impar"
            mkdir "C:\Users\Server\Desktop\Impares"
        }

Write-Host "-----------------------------------"
#Crear ficheros
Write-Host "Ejercicio 6"
mkdir C:\Users\Administrador\Documents\Logs
for($i=0; $i -le 10; $i++){
    New-Item -Path C:\Users\Administrador\Documents\Logs\log$i.txt -ItemType file
}
Write-Host "-----------------------------------"
#Listar ficheros
Write-Host "Ejercicio 7.1"
$i = @(ls $env:HOME\Documents\Logs)
foreach($a in $i){
    write-host "Este es el fichero $a"
}
Write-Host "-----------------------------------"
#Tipo de fichero
Write-Host "Ejercicio 7.2"
mkdir $env:HOME\Documents\Ficheros
New-Item -path $env:HOME\Documents\Ficheros\datos.csv -ItemType file
New-Item -path $env:HOME\Documents\Ficheros\Informe.docx -ItemType file
New-Item -path $env:HOME\Documents\Ficheros\Imagen.png -ItemType File
Write-Host "------------------------------------"
Write-Host "Ejercicio 8"
$i = @(Get-ChildItem $env:HOME\Documents\Ficheros)
foreach($a in $i){
    if ($a.Name -like '*.csv') {
        Write-Host "$($a.Name) Es un fichero de datos"
    }
    elseif ($a.Name -like '*.docx') {
        Write-Host "$($a.Name) Es un documento de texto"
    }
    elseif ($a.Name -like '*.png') {
        Write-Host "$($a.Name) Es una imagen"
    }
    else {
        Write-Host "$($a.Name) Tipo de fichero no reconocido"
    }
    write-host "Este es el fichero $a"

}