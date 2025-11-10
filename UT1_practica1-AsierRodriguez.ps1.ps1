
<#
    .SYNOPSIS
        Examen power shell.

    .DESCRIPTION
        Este script recopila información del inventario de la PC y la exporta a un archivo CSV.
        También puede concatenar múltiples archivos CSV en un informe único.

    .PARAMETER c
        Switch para concatenar archivos CSV de inventario en un solo informe.
    
    .PARAMETER outputPath
        Ruta donde se guardarán los archivos de inventario.
    
    .PARAMETER LogPath
        Ruta donde se guardarán los archivos de log.
    
    .PARAMETER SessionCode
        Iniciales del alumno para identificación en logs.

    .EXAMPLE
        .\PowerShell-PC-Inventory.ps1 -c
        Concatena todos los archivos CSV de inventario en un único informe.

    .NOTES
        Autor: Asier
        Fecha: 10/11/2025
        Versión: 1.0
#>

param(
    [string]$OutputPath = "$env:USERPROFILE\Documents\Inventory",
    [string]$LogPath = "$env:USERPROFILE\Documents\Inventory\Logs",
    [ValidateNotNullOrEmpty()]
    [string]$SessionCode = "ARO",  # iniciales del alumno

    [Parameter()]
    [switch]$Concatenate
)
# Configurar preferencias para suprimir mensajes de error en terminal
$ErrorActionPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

# Inicializar variables de rutas críticas
$ErrorLogPath = Join-Path -Path $LogPath -ChildPath "PowerShell-PC-Inventory-Error-Log.log"
$inventoryDir = Join-Path -Path $OutputPath -ChildPath "InventoryOutput"
$csv = Join-Path -Path $inventoryDir -ChildPath "$env:computername-Inventory.csv"

# Función para escribir en el log con formato específico
function Write-Log {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet('INFO','WARN','ERROR')]
        [string]$Level,
        
        [string]$LogFilePath = $LogPath  # Usamos la ruta global de logs
    )
    
    # Asegurarse de que existe el directorio del log
    $logDir = Split-Path -Parent $LogFilePath
    if (-not (Test-Path $logDir)) {
        try {
            New-Item -ItemType Directory -Path $logDir -Force | Out-Null
        }
        catch {
            # Si no podemos crear en la ruta especificada, usar Documents
            $LogFilePath = Join-Path -Path ([Environment]::GetFolderPath("MyDocuments")) -ChildPath "PowerShell-PC-Inventory.log"
        }
    }
    
    # Crear la línea del log con el formato requerido
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "[$timestamp] <$Level> <$env:COMPUTERNAME> <$SessionCode> $Message"
    
    try {
        Add-Content -Path $LogFilePath -Value $logLine -ErrorAction Stop
    }
    catch {
        # Si falla escribir en el log, intentar en Documents como respaldo
        $fallbackPath = Join-Path -Path ([Environment]::GetFolderPath("MyDocuments")) -ChildPath "PowerShell-PC-Inventory.log"
        Add-Content -Path $fallbackPath -Value $logLine -ErrorAction SilentlyContinue
    }
}

# Inicializar variables de rutas críticas
$ErrorLogPath = Join-Path -Path $LogPath -ChildPath "PowerShell-PC-Inventory-Error-Log.log"
$inventoryDir = Join-Path -Path $outputPath -ChildPath "InventoryOutput"
$csv = Join-Path -Path $inventoryDir -ChildPath "$env:computername-Inventory.csv"

# Comprobar si la ruta de salida existe, si no, crearla
if (-not (Test-Path $OutputPath)) {
    try {
        New-Item -ItemType Directory -Path $OutputPath -ErrorAction Stop | Out-Null
        Write-Log -Level 'INFO' -Message "Creado directorio de salida: $OutputPath"
    }
    catch {
        Write-Log -Level 'WARN' -Message "No se pudo crear la ruta de salida especificada. Se redirige a Documents."
        $script:OutputPath = Join-Path -Path $env:USERPROFILE -ChildPath "Documents"
        Write-Log -Level 'INFO' -Message "Nueva ruta de salida: $OutputPath"
    }
}
# Función que prueba si podemos escribir en la ruta de salida. Crea un archivo temporal, lo borra y devuelve $true/$false.
function Test-WriteAccess {
  param(
    [string]$PathToTest = $outputPath
  )

  try {
    # Asegurarse de que la carpeta exista
    if (-not (Test-Path $PathToTest)) {
      New-Item -ItemType Directory -Path $PathToTest -ErrorAction Stop | Out-Null
    }

    # Crear un archivo temporal en la ruta indicada
    $tempFile = Join-Path -Path $PathToTest -ChildPath ([System.IO.Path]::GetRandomFileName() + ".tmp")
    Set-Content -Path $tempFile -Value "PowerShell write test" -ErrorAction Stop

    # Si hemos llegado hasta aquí, se pudo escribir: borrar el temporal
    Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue

    return $true
  }
  catch {
    # Si falla, asegurarnos de tener una ruta de log razonable dentro de la ruta de prueba o en D:\Usuarios\username\Documents
    if (-not $ErrorLogPath) {
      try {
        $ErrorLogPath = Join-Path -Path $PathToTest -ChildPath "PowerShell-PC-Inventory-Error-Log.log"
      }
      catch {
        $ErrorLogPath ="$env:USERPROFILE\Documents\PowerShell-PC-Inventory-Error-Log.log"
      }
    }

    if (-not (Test-Path $ErrorLogPath)) {
      try {
        New-Item -ItemType File -Path $ErrorLogPath -Force | Out-Null
      }
      catch {
        # si no podemos crear el log, no hacemos más
      }
    }

    Write-Log -Level 'WARN' -Message "No se pudo escribir en la ruta '$PathToTest'. Se cambia a Documentos para la salida." -LogFilePath $ErrorLogPath

    # Cambiar la ruta de salida a la ruta local (Documentos del usuario)
    $script:outputPath = [Environment]::GetFolderPath("MyDocuments")

    return $false
  }
}


# Probar si tenemos acceso de escritura a la ruta de salida configurada; esto puede modificar $outputPath si falla
Test-WriteAccess -PathToTest $outputPath | Out-Null
# Inicializar variables de rutas críticas
$ErrorLogPath = Join-Path -Path $LogPath -ChildPath "PowerShell-PC-Inventory-Error-Log.log"
$inventoryDir = Join-Path -Path $outputPath -ChildPath "InventoryOutput"
$csv = Join-Path -Path $inventoryDir -ChildPath "$env:computername-Inventory.csv"

# Función para asegurar que un directorio existe, con fallback a Documents si falla
function Test-AndCreateDirectory {
    param (
        [string]$Path,
        [string]$Description
    )
    
    if (-not (Test-Path $Path)) {
        try {
            New-Item -ItemType Directory -Path $Path -ErrorAction Stop | Out-Null
            Write-Log -Level 'INFO' -Message "Creado directorio para $Description en: $Path"
            return $Path
        }
        catch {
            $fallbackPath = Join-Path -Path ([Environment]::GetFolderPath("MyDocuments")) -ChildPath (Split-Path -Leaf $Path)
            Write-Log -Level 'WARN' -Message "No se pudo crear el directorio en $Path. Usando alternativa: $fallbackPath"
            New-Item -ItemType Directory -Path $fallbackPath -Force | Out-Null
            return $fallbackPath
        }
    }
    return $Path
}

# Asegurar que existan los directorios necesarios
$outputPath = Ensure-Directory -Path $outputPath -Description "salida principal"
$LogPath = Ensure-Directory -Path $LogPath -Description "logs"
$inventoryDir = Ensure-Directory -Path $inventoryDir -Description "inventario"

# Actualizar ruta del CSV si cambió el directorio de inventario
$csv = Join-Path -Path $inventoryDir -ChildPath "$env:computername-Inventory.csv"

# comprobar aplicaciones instaladas (1 = sí, 0 = no)
if ($SessionCode -eq "ARO") {
    $checkInstalledApps = 1
} else {
    $checkInstalledApps = 0
}

function ConcatenateInventory {
    <#
    .SYNOPSIS
        Concatena múltiples archivos CSV de inventario en un solo archivo.
    .DESCRIPTION
        Combina todos los archivos CSV de inventario encontrados en la carpeta especificada,
        eliminando duplicados para evitar encabezados repetidos.
    #>
    
    Write-Log -Level 'INFO' -Message "Iniciando proceso de concatenación de inventarios"
    
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    
    # Usar el directorio de inventario por defecto si no se especifica otro
    $csvFolderPath = Read-Host "Ruta de la carpeta con los archivos CSV de inventario [$inventoryDir]"
    if ([string]::IsNullOrWhiteSpace($csvFolderPath)) {
        $csvFolderPath = $inventoryDir
    }
    
    if (-not (Test-Path $csvFolderPath)) {
        Write-Log -Level 'ERROR' -Message "La ruta de origen no existe: $csvFolderPath"
        return
    }
    
    # Usar el directorio de salida por defecto
    $outputFilePath = $outputPath
    Write-Log -Level 'INFO' -Message "Usando directorio de salida: $outputFilePath"
    
    # Verificar y crear el directorio de salida si es necesario
    $outputFilePath = Ensure-Directory -Path $outputFilePath -Description "informe concatenado"
    
    # Inicializar tabla hash para filas únicas
    $uniqueRows = @{}
    $filesProcessed = 0
    
    try {
        # Procesar cada archivo CSV
        Get-ChildItem -Path $csvFolderPath -Filter "*.csv" | ForEach-Object {
            $csvFile = $_.FullName
            Write-Log -Level 'INFO' -Message "Procesando archivo: $($_.Name)"
            
            try {
                $data = Import-Csv -Path $csvFile
                foreach ($row in $data) {
                    $rowKey = $row | ConvertTo-Json # Mejor que Out-String para comparar objetos
                    if (-not $uniqueRows.ContainsKey($rowKey)) {
                        $uniqueRows[$rowKey] = $row
                    }
                }
                $filesProcessed++
            }
            catch {
                Write-Log -Level 'WARN' -Message "Error al procesar $($_.Name): $_"
            }
        }
        
        if ($filesProcessed -eq 0) {
            Write-Log -Level 'WARN' -Message "No se encontraron archivos CSV para procesar en $csvFolderPath"
            return
        }
        
        # Crear el archivo de salida
        $outputFile = Join-Path -Path $outputFilePath -ChildPath "PowerShell-PC-Inventory-Report-$timestamp.csv"
        $uniqueRows.Values | Export-Csv -Path $outputFile -NoTypeInformation -Force
        
        Write-Log -Level 'INFO' -Message "Inventario combinado completado. Procesados $filesProcessed archivos."
        Write-Host "El informe de inventario se ha guardado en: $outputFile"
    }
    catch {
        Write-Log -Level 'ERROR' -Message "Error durante la concatenación: $_"
        throw "Error al procesar los archivos de inventario: $_"
    }
}

if ($Concatenate) {
    Write-Log -Level 'INFO' -Message 'Iniciando modo concatenación'
    ConcatenateInventory
    return
}

Write-Log -Level 'INFO' -Message "Recopilando información del inventario..."

# Fecha y hora de la recopilación
$Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Aplicaciones instaladas
if ($checkInstalledApps -eq 1) {
  # Obtener la lista de aplicaciones instaladas desde el registro
  $installedApps = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" `
     -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty DisplayName

  # Filtrar las entradas vacías y unirlas en una lista separada por comas
  $appsList = ($installedApps | Where-Object { $_ -ne $null }) -join "`n "

  # Mostrar la variable
  $appsList
} else {
  $appsList = "N/A"
}


# BIOS Version/Fecha/Nombre
$BIOSManufacturer = Get-CimInstance -Class win32_bios | Select-Object -ExpandProperty Manufacturer
$BIOSVersion = Get-CimInstance -Class win32_bios | Select-Object -ExpandProperty SMBIOSBIOSVersion
$BIOSName = Get-CimInstance -Class win32_bios | Select-Object -ExpandProperty Name
$BIOS = Write-Output $BIOSManufacturer", "$BIOSVersion", "$BIOSName

# Dirección IP y dirección MAC
# Obtener la ruta predeterminada con la métrica más baja
$defaultRoute = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Sort-Object -Property Metric | Select-Object -First 1
# Obtener el índice de interfaz para la ruta predeterminada
$interfaceIndex = $defaultRoute.InterfaceIndex
# Obtener la dirección IP asociada con esta interfaz
$interfaceIP = (Get-NetIPAddress -InterfaceIndex $interfaceIndex | Where-Object { $_.AddressFamily -eq "IPv4" }).IPAddress
# Obtener la dirección MAC asociada con esta interfaz
$interfaceMAC = (Get-NetAdapter -InterfaceIndex $interfaceIndex).MacAddress

# Número de serie/Service Tag
$SN = Get-CimInstance -Class Win32_Bios | Select-Object -ExpandProperty SerialNumber

# Modelo
$Model = Get-CimInstance -Class Win32_ComputerSystem | Select-Object -ExpandProperty Model

# CPU
$CPU = Get-CimInstance -Class win32_processor | Select-Object -ExpandProperty Name

# RAM
$RAM = Get-CimInstance -Class Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | ForEach-Object { [math]::Round(($_.sum / 1GB),2) }

# Almacenamiento
$Storage = Get-CimInstance -Class Win32_LogicalDisk -Filter "DeviceID='$env:systemdrive'" | ForEach-Object { [math]::Round($_.Size / 1GB,2) }

#GPU(s)
function GetGPUInfo {
  $GPUs = Get-CimInstance -Class Win32_VideoController
  foreach ($GPU in $GPUs) {
    $GPU | Select-Object -ExpandProperty Description
  }
}

#Comprueba y obtiene la información de hasta 2 GPUs conectadas
$GPU0 = GetGPUInfo | Select-Object -Index 0
$GPU1 = GetGPUInfo | Select-Object -Index 1

# Sistema operativo
$OS = Get-CimInstance -Class Win32_OperatingSystem

# Versión del sistema operativo ya está incluida en $os.BuildNumber, no necesitamos $OSBuild

# Tiempo de actividad
# Obtener la última hora de arranque del sistema
$lastBootTime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
# Calcular el tiempo de actividad restando la última hora de arranque de la hora actual
$uptime = (Get-Date) - $lastBootTime
# Mostrar el tiempo de actividad en un formato legible
$uptimeReadable = "{0} días, {1} horas, {2} minutos" -f $uptime.Days,$uptime.Hours,$uptime.Minutes

# Nombre de usuario
$Username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# Monitor(es)
function GetMonitorInfo {
  # Gracias a https://github.com/MaxAnderson95/Get-Monitor-Information
  $Monitors = Get-CimInstance -Namespace "root\WMI" -Class "WMIMonitorID"
  foreach ($Monitor in $Monitors) {
    ([System.Text.Encoding]::ASCII.GetString($Monitor.ManufacturerName)).Replace("$([char]0x0000)","")
    ([System.Text.Encoding]::ASCII.GetString($Monitor.UserFriendlyName)).Replace("$([char]0x0000)","")
    ([System.Text.Encoding]::ASCII.GetString($Monitor.SerialNumberID)).Replace("$([char]0x0000)","")
  }
}

#Comprueba y obtiene la información de hasta 3 monitores conectados si hay alguno en blanco que lo muestre como N/A
$Monitor1 = GetMonitorInfo | Select-Object -Index 0,1
if (-not $Monitor1[0]) {$Monitor1[0] = "N/A"}
$Monitor1SN = GetMonitorInfo | Select-Object -Index 2
if (-not $Monitor1SN) {$Monitor1SN = "N/A"}
$Monitor2 = GetMonitorInfo | Select-Object -Index 3,4
if (-not $Monitor2[0]) {$Monitor2[0] = "N/A"}
$Monitor2SN = GetMonitorInfo | Select-Object -Index 5
if (-not $Monitor2SN) {$Monitor2SN = "N/A"}
$Monitor3 = GetMonitorInfo | Select-Object -Index 6,7
if (-not $Monitor3[0]) {$Monitor3[0] = "N/A"}
$Monitor3SN = GetMonitorInfo | Select-Object -Index 8
if (-not $Monitor3SN) {$Monitor3SN = "N/A"}

$Monitor1 = $Monitor1 -join ' '
$Monitor2 = $Monitor2 -join ' '
$Monitor3 = $Monitor3 -join ' '

# Tipo de ordenador (chasis)
# Valores de https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-systemenclosure
$Chassis = Get-CimInstance -ClassName Win32_SystemEnclosure -Namespace 'root\CIMV2' -Property ChassisTypes | Select-Object -ExpandProperty ChassisTypes

$ChassisDescription = switch ($Chassis) {
  "1" { "Other" }
  "2" { "Unknown" }
  "3" { "Desktop" }
  "4" { "Low Profile Desktop" }
  "5" { "Pizza Box" }
  "6" { "Mini Tower" }
  "7" { "Tower" }
  "8" { "Portable" }
  "9" { "Laptop" }
  "10" { "Notebook" }
  "11" { "Hand Held" }
  "12" { "Docking Station" }
  "13" { "All in One" }
  "14" { "Sub Notebook" }
  "15" { "Space-Saving" }
  "16" { "Lunch Box" }
  "17" { "Main System Chassis" }
  "18" { "Expansion Chassis" }
  "19" { "SubChassis" }
  "20" { "Bus Expansion Chassis" }
  "21" { "Peripheral Chassis" }
  "22" { "Storage Chassis" }
  "23" { "Rack Mount Chassis" }
  "24" { "Sealed-Case PC" }
  "30" { "Tablet" }
  "31" { "Convertible" }
  "32" { "Detachable" }
  default { "Unknown" }
}

# Función para escribir el inventario en el archivo CSV
function OutputToCSV {
  # Propiedades del CSV
  # Gracias a https://gallery.technet.microsoft.com/scriptcenter/PowerShell-Script-Get-beced710
  Write-Log -Level 'INFO' -Message "Agregando información del inventario al archivo CSV..."
  $infoObject = New-Object PSObject
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Date Collected" -Value $Date
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Hostname" -Value $env:computername
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "IP Address" -Value $interfaceIP
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "MAC Address" -Value $interfaceMAC
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "User" -Value $Username
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Type" -Value $ChassisDescription
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Serial Number/Service Tag" -Value $SN
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Model" -Value $Model
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "BIOS" -Value $BIOS
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "CPU" -Value $CPU
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "RAM (GB)" -Value $RAM
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Storage (GB)" -Value $Storage
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "GPU 0" -Value $GPU0
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "GPU 1" -Value $GPU1
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "OS" -Value $os.Caption
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "OS Version" -Value $os.BuildNumber
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Up time" -Value $uptimeReadable
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Monitor 1" -Value $Monitor1
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Monitor 1 Serial Number" -Value $Monitor1SN
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Monitor 2" -Value $Monitor2
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Monitor 2 Serial Number" -Value $Monitor2SN
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Monitor 3" -Value $Monitor3
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Monitor 3 Serial Number" -Value $Monitor3SN
  Add-Member -InputObject $infoObject -MemberType NoteProperty -Name "Installed Apps" -Value $appsList
  $infoObject
  $infoColl += $infoObject

  # Salida al archivo CSV
  try {
    $infoColl | Export-Csv -Path $csv -NoTypeInformation
    Write-Host -ForegroundColor Green "Inventory was successfully updated!"
    exit 0
  }
  catch {
    if (-not (Test-Path $ErrorLogPath))
    {
      New-Item -ItemType "file" -Path $ErrorLogPath
      icacls $ErrorLogPath /grant Everyone:F
    }
    Write-Log -Level 'ERROR' -Message "$Username was unable to export to the inventory file at $csv" -LogFilePath $ErrorLogPath
    throw "Unable to export to the CSV file. Please check the permissions on the file."
    exit 1
  }
}

# comprobar si el archivo CSV existe, si no, crearlo
Write-Host "Comprobando si el archivo CSV existe..."
if (-not (Test-Path $csv))
{
  Write-Host "Creando archivo CSV..."
  try {
    New-Item -ItemType "file" -Path $csv
    icacls $csv /grant Everyone:F
    OutputToCSV
  }
  catch {
    if (-not (Test-Path $ErrorLogPath))
    {
      New-Item -ItemType "file" -Path $ErrorLogPath
      icacls $ErrorLogPath /grant Everyone:F
    }
    Write-Log -Level 'ERROR' -Message "$Username was unable to create the inventory file at $csv" -LogFilePath $ErrorLogPath
    throw "Unable to create the CSV file. Please check the permissions on the file."
    exit 1
  }
}

# Comprobar si el fichero csv existe, si no, crearlo
function Test-CSVExists {
  Write-Host "Comprobando si el archivo CSV existe en el inventario..."
  $import = Import-Csv $csv
  if ($import -match $env:computername)
  {
    try {
      (Get-Content $csv) -notmatch $env:computername | Set-Content $csv
      OutputToCSV
    }
    catch {
      if (-not (Test-Path $ErrorLogPath))
      {
        New-Item -ItemType "file" -Path $ErrorLogPath
        icacls $ErrorLogPath /grant Everyone:F
      }
      Write-Log -Level 'ERROR' -Message "$Username was unable to import and/or modify the inventory file at $csv" -LogFilePath $ErrorLogPath
      throw "imposible importar y/o modificar el archivo CSV. Por favor, compruebe los permisos del archivo."
      exit 1
    }
  }
  else
  {
    OutputToCSV
  }
}

Check-IfCSVExists
