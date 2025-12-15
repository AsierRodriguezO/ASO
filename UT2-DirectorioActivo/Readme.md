# 📁 ASO - UT2: Infraestructura de Dominio y Conectividad WAN con pfSense

Este repositorio contiene la documentación de las prácticas realizadas en la **Unidad de Trabajo 2 (UT2)** de la asignatura **Administración de Sistemas Operativos (ASO)**. Se ha diseñado e implementado una infraestructura completa de red con servicios de dominio y conectividad a Internet mediante un firewall **pfSense**.

## 🧩 Actividades Implementadas

### ✅ **Actividad 1: Configuración Básica de Dominio**
- Creación de un **bosque de Active Directory** desde cero en **Windows Server 2025**.
- Promoción del servidor `WS-GUI-XXX-DC1` como **primer Controlador de Dominio (DC)**.
- Configuración del dominio **`aro.local`** con DNS integrado.
- Unión de dos clientes al dominio:
  - `WS-GUI-XXX-DC2` (Windows Server 2025)
  - `W11` (Windows 11)
- Validación de conectividad mediante `ping` y pertenencia al dominio.
- Exportación del **script de PowerShell** generado durante la promoción para futuras automatizaciones.

### ✅ **Actividad 2: Implementación de pfSense como Gateway**
- Instalación y configuración de **pfSense CE 2.8.x** en una VM con:
  - **Interfaz WAN**: modo puente (acceso a Internet).
  - **Interfaz LAN**: red privada `VMnet1` (`192.168.111.0/24`).
- Configuración de:
  - **NAT** para salida a Internet.
  - **DHCP** en LAN (rango `192.168.111.100 – 199`, evitando conflicto con el DC).
  - **Puerta de enlace**: `192.168.111.1`.
- Integración con el dominio:
  - El DC usa **`127.0.0.1`** como DNS y **`192.168.111.1`** como puerta de enlace.
  - Configuración de **reenviadores DNS** en el DC hacia pfSense para resolución externa.

### ✅ **Actividad 3: Segundo Controlador de Dominio**
- Promoción de `WS-GUI-XXX-DC2` como **segundo DC** en el dominio existente (`aro.local`).
- Instalación del rol **AD DS** y configuración como **servidor DNS secundario**.
- Replicación de Active Directory desde el DC principal (`WS-GUI-XXX-DC1`).
- Verificación de replicación con el comando:
  ```powershell
  repadmin /showrepl