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
clear-host
$cursos = @("Asir1","Asir2","Daw1","Daw2","Dam1","Dam2","Smr1","Smr2","Smrd1","Smrd2")
foreach ($curso in $cursos){

     if (Test-Path("$env:userprofile\Desktop\Cursos\$curso")){
        write-host "El directorio $curso ya existe."
    } else {
        mkdir $env:userprofile\Desktop\Cursos\$curso
        for($i=1;$i -le 20;$i++){
        mkdir $env:userprofile\Desktop\Cursos\$curso\$Curso$i
    }
    write-host "El directorio $curso se ha creado correctamente"
    }
}

