# CE 4.10 — Administración remota gráfica (RDP) 🖥️🔒

---

## 🎯 Objetivo
Configurar y documentar acceso remoto por Escritorio Remoto (RDP) desde **Windows 11** a **Windows Server** mediante un **usuario dedicado** `remoto_rdp`, con control explícito del acceso y Autenticación de Nivel de Red (NLA).

---

## 🏗️ Infraestructura
- Windows Server 2022 (o equivalente) — servidor destino
- Windows 11 — cliente de administración (mstsc)
- Red privada

---

## ✅ Pasos resumidos
1. Habilitar Escritorio Remoto en el equipo (Interfaz gráfica o PowerShell).
2. Crear usuario local `remoto_rdp` y añadirlo al grupo **Usuarios de Escritorio remoto** (`Remote Desktop Users`). No usar el usuario Administrador.
3. Activar Autenticación de Nivel de Red (NLA) para las conexiones RDP.
4. Permitir RDP en el firewall del servidor.
5. Desde Windows 11, conectar con `remoto_rdp` usando el cliente de Escritorio Remoto y comprobar la sesión gráfica.
6. Verificar que otro usuario distinto a `remoto_rdp` no puede acceder por RDP (acceso denegado).

---

## 🔧 Comandos rápidos (PowerShell, ejecutar como Administrador)
- Habilitar Escritorio Remoto:
  - Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
- Habilitar NLA:
  - Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 1
- Abrir puerto en firewall (Remote Desktop):
  - Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
- Crear usuario local y añadir al grupo:
  - $pwd = ConvertTo-SecureString "ContraseñaSegura123!" -AsPlainText -Force
  - New-LocalUser -Name "remoto_rdp" -Password $pwd -FullName "Usuario remoto RDP"
  - Add-LocalGroupMember -Group "Remote Desktop Users" -Member "remoto_rdp"
- Verificar miembros del grupo:
  - Get-LocalGroupMember -Group "Remote Desktop Users"

> Nota: Si el servidor es parte de un dominio, use los cmdlets y procedimientos adecuados para cuentas de dominio y grupos (Add-ADGroupMember, etc.).

---

## 🔁 Comprobaciones recomendadas
- Confirmar que la política de seguridad y las configuraciones de red permiten conexiones RDP.
- Probar conexión desde Windows 11 con `mstsc` (mstsc /v:IP_DEL_SERVIDOR) y autenticación NLA.
- Intentar acceso con otro usuario para comprobar rechazo de conexión.

---

## 📋 Documentación (ejemplo para el README)
```
## Acceso RDP
Usuario RDP: remoto_rdp  
Sistema administrado: Windows Server 2022  
Protocolo: RDP  
Grupo de acceso: Usuarios de Escritorio remoto  
Cifrado / NLA: Sí  
```

---

## 📸 Evidencias (añadir en `evidencias/`)
1. `1_usuario_creado_rdp.png` — Usuario `remoto_rdp` creado y añadido al grupo Usuarios de Escritorio remoto.
![imagenes](/ASO-UT4-Admin-Remota/capturas/rpd.png)

![imagenes](/ASO-UT4-Admin-Remota/capturas/rpd1.png)
2. `2_nla_habilitada.png` — Configuración donde se vea que la Autenticación de Nivel de Red está habilitada.
![imagenes](/ASO-UT4-Admin-Remota/capturas/rpd2.png)
3. `3_sesion_rdp.png` — Sesión RDP activa mostrando el escritorio del servidor con `remoto_rdp` conectado.
![imagenes](/ASO-UT4-Admin-Remota/capturas/rpd3.png)

![imagenes](/ASO-UT4-Admin-Remota/capturas/rpd4.png)
4. `4_acceso_denegado.png` — Captura de intento fallido de acceso con un usuario distinto a `remoto_rdp`.
![imagenes](/ASO-UT4-Admin-Remota/capturas/rpd5.png)

