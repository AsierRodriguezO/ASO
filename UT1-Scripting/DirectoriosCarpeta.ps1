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
$cursos = @("Asir1","Asir2","Daw1","Daw2","Dam1","Dam2","Smr1","Smr2","Smrd1","Smrd2")
foreach ($curso in $cursos){

     if ((mkdir "$env:userhome\Desktop\$curso") -eq $true){
        write-host "El directorio $curso ya existe"
    } else {{
        mkdir $env:userhome\Desktop\$curso
        for($i=1;$i -le 20;$i++){
        mkdir $env:userhome\Desktop\$curso\$i
    }
    write-host "El directorio $curso se ha creado correctamente"
    }
}
}