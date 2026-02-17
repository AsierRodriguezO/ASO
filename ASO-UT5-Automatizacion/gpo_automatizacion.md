# RA5 — Automatización con GPO (resumen) ⚙️

---

## 🎯 Objetivo
Implementar automatizaciones administrativas en Windows Server mediante **Políticas de Grupo (GPO)**:
- **Tarea 1:** Mapeo automático de unidades de red según el grupo del usuario.
- **Tarea 2:** Despliegue y programación de un script de limpieza automática en clientes mediante GPO.

---

## 🏗️ Infraestructura
- Windows Server 2025 (controlador/dominio)
- Windows 11 (clientes)
- Red privada

---

## 🌳 Estructura de Active Directory (propuesta)
Dominio: `[INICIALES].local`
- UO_Administracion (2 usuarios: user_admin1, user_admin2)
- UO_Informatica (2 usuarios: user_info1, user_info2)
- UO_Usuarios (2 usuarios: user_user1, user_user2)

**Grupos de seguridad**:
- GRP_Administracion (miembros: usuarios de UO_Administracion)
- GRP_Informatica (miembros: usuarios de UO_Informatica)

---

## 📋 Criterios de evaluación
Esta práctica evalúa los criterios RA5: **CE3.3, CE3.4, CE3.6, CE3.7, CE3.8**.

---

## Tarea 1 — Mapeo Automático de Unidades de Red 🗂️

### Objetivo
Mapear automáticamente unidades al iniciar sesión según el grupo de seguridad del usuario, con un recurso común para todos y permisos que impidan accesos cruzados.

### Requisitos funcionales
- Mapear unidades al iniciar sesión.
- Administracion y Informatica ven unidades distintas.
- Existencia de un recurso común para todos.
- Permisos NTFS y de recurso compartido restringen el acceso.

### Estructura de carpetas compartidas (en servidor)
C:\Compartidas\
├── Admin\
├── Informatica\
└── Comun\

**Comparticiones y accesos**
- C:\Compartidas\Admin  → Compartida-Admin   → Solo **GRP_Administracion**
- C:\Compartidas\Informatica → Compartida-Info → Solo **GRP_Informatica**
- C:\Compartidas\Comun → Compartida-Todos → **Todos los usuarios** (o grupo específico que represente a todos)

### Crear GPO de mapeo
- Nombre de GPO: **Mapeo-Unidades-[INICIALES]**
- Ruta en GPMC: **User Configuration > Preferences > Windows Settings > Drive Maps**
- Crear 3 entradas:
  - Unidad Z: \servidor\Compartida-Admin (acción: Create; item-level targeting → Security Group → user is a member of → GRP_Administracion)
  - Unidad Y: \servidor\Compartida-Info   (item-level targeting → GRP_Informatica)
  - Unidad X: \servidor\Compartida-Todos  (aplicable a todos)
- Vincular la GPO a las UO: UO_Administracion, UO_Informatica, UO_Usuarios.

### Verificación
- Prueba con distintos usuarios:
  - user_admin1 (GRP_Administracion): debe ver Z: y X:, no Y:
  - user_info1 (GRP_Informatica): debe ver Y: y X:, no Z:
- Intentar acceder \servidor\Compartida-Admin con un usuario de Informática → Debe aparecer **Acceso denegado**.

### Evidencias requeridas (mapeo)
1. `1_estructura_compartidas.png` — Estructura de carpetas en C:\Compartidas\
![](/ASO-UT5-Automatizacion/images/mapeado1.png)
2. `2_permisos_compartida_admin.png` — Pestañas Compartir + Seguridad para `Compartida-Admin`
![](/ASO-UT5-Automatizacion/images/mapeado2.png)
![](/ASO-UT5-Automatizacion/images/mapeado3.png)
3. `3_gpo_mapeo_gpmc.png` — GPO **Mapeo-Unidades-[INICIALES]** creada y vinculada
![](/ASO-UT5-Automatizacion/images/mapeado4.png)
![](/ASO-UT5-Automatizacion/images/mapeado5.png)
![](/ASO-UT5-Automatizacion/images/mapeado6.png)
4. `4_config_unidades_gpo.png` — Configuración de las 3 unidades en la GPO
![](/ASO-UT5-Automatizacion/images/mapeado7.png)

1. `5_explorer_user_admin1.png` — Explorador de user_admin1
![](/ASO-UT5-Automatizacion/images/mapeado8.png)
![](/ASO-UT5-Automatizacion/images/mapeado9.png)
1. `6_explorer_user_info1.png` — Explorador de user_info1
![](/ASO-UT5-Automatizacion/images/mapeado10.png)
![](/ASO-UT5-Automatizacion/images/mapeado11.png)
2. `7_acceso_denegado.png` — Captura de intento fallido a acceso no autorizado
![](/ASO-UT5-Automatizacion/images/mapeado12.png)

---

## Tarea 2 — Script de limpieza automático 🧹

### Objetivo
Desplegar mediante GPO una tarea programada en los equipos cliente que ejecute un script de limpieza de temporales, registre la ejecución y se ejecute sin intervención del usuario.

### Requisitos funcionales
- Limpieza automática de archivos temporales.
- Ejecución programada semanalmente.
- Generación de un log por ejecución en `C:\Logs`.
- Despliegue automático vía GPO (no intervención manual en cada equipo).

### Script ejemplo (PowerShell: `limpieza.ps1`)
```powershell
# limpieza.ps1
$logDir = 'C:\Logs'
if (-not (Test-Path $logDir)) { New-Item -Path $logDir -ItemType Directory -Force }
$logFile = Join-Path $logDir "limpieza_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$paths = @("C:\Windows\Temp", "$env:TEMP")
foreach ($p in $paths) {
    try {
        Get-ChildItem -Path $p -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Add-Content -Path $logFile -Value "[$(Get-Date)] Limpieza de $p completada"
    } catch {
        Add-Content -Path $logFile -Value "[$(Get-Date)] Error limpiando $p: $_"
    }
}
```

### Despliegue del script
- Copiar `limpieza.ps1` a `\\[dominio].local\SYSVOL\[dominio].local\scripts\`

### Crear GPO de mantenimiento
- Nombre de GPO: **Mantenimiento-Automatico-[INICIALES]**
- En GPMC: **Computer Configuration > Preferences > Control Panel Settings > Scheduled Tasks**
- Crear una tarea:
  - Programación: Semanal (día/hora a elegir)
  - Ejecutar con cuenta: **SYSTEM**
  - Marcar: Run with highest privileges
  - Acción: Program -> Program/script: `powershell.exe`
    - Add arguments: `-ExecutionPolicy Bypass -File "\\[dominio].local\SYSVOL\[dominio].local\scripts\limpieza.ps1"`
- Vincular la GPO a **UO_Usuarios** (o al contenedor de equipos apropiado).

### Verificación
En un cliente:
- Ejecutar `gpupdate /force`
- Abrir `Task Scheduler` (taskschd.msc) y comprobar que la tarea existe
- Ejecutar la tarea manualmente y comprobar que el log se creó en `C:\Logs`

### Evidencias requeridas (mantenimiento)
1. `1_gpo_mantenimiento_gpmc.png` — GPO **Mantenimiento-Automatico-[INICIALES]** creada y vinculada
  ![](/ASO-UT5-Automatizacion/images/mantenimiento1.png)
  ![](/ASO-UT5-Automatizacion/images/mantenimiento2.png)
1. `2_tarea_gpo_config.png` — Configuración de la tarea en la GPO 
   ![](/ASO-UT5-Automatizacion/images/mantenimiento3.png)
   ![](/ASO-UT5-Automatizacion/images/mantenimiento4.png)
2. `3_tarea_cliente_taskschd.png` — Tarea visible en el Programador del cliente
   ![](/ASO-UT5-Automatizacion/images/mantenimiento5.png)
3. `4_ejecucion_exitosa.png` — Ejecución exitosa (estado o historial)
   ![](/ASO-UT5-Automatizacion/images/mantenimiento6.png)
4. `5_contenido_log.png` — Contenido del log generado (abierto con Bloc de notas)
 ![](/ASO-UT5-Automatizacion/images/mantenimiento7.png)