# CE 4.9 — Acceso SSH seguro (resumen) 🔒

---

## 🎯 Objetivo
Configurar acceso SSH seguro desde **Windows 11 (PuTTY)** a **Ubuntu Server 24.04** mediante **autenticación por clave pública** con el usuario exclusivo `remoto_ssh`.

---

##  Infraestructura
- Windows Server 2025 (infraestructura)
- Ubuntu Server 24.04 (servidor destino)
- Windows 11 (cliente de administración con PuTTY / PuTTYgen)
- Red privada

---

## ✅ Pasos resumidos
1. Verificar servicio SSH: `sudo systemctl status ssh`
2. Crear usuario: `sudo adduser --disabled-password --gecos "" remoto_ssh`
3. Generar clave en PuTTYgen (Ed25519 recomendado); guardar `remoto_ssh.ppk` (privada).
4. Copiar la clave pública a `/home/remoto_ssh/.ssh/authorized_keys` y ajustar permisos:
   - `sudo mkdir -p /home/remoto_ssh/.ssh`
   - `sudo chown remoto_ssh:remoto_ssh /home/remoto_ssh/.ssh`
   - `sudo chmod 700 /home/remoto_ssh/.ssh`
   - `echo "<clave pública>" | sudo tee /home/remoto_ssh/.ssh/authorized_keys`
   - `sudo chmod 600 /home/remoto_ssh/.ssh/authorized_keys`
5. Comprobar acceso desde PuTTY con `remoto_ssh` (sin contraseña).
6. Si funciona, deshabilitar contraseñas en `/etc/ssh/sshd_config` (`PasswordAuthentication no`) y reiniciar: `sudo systemctl restart ssh`.

---

## 🔧 Comandos rápidos
- Estado SSH: `sudo systemctl status ssh`
- Crear usuario: `sudo adduser --disabled-password --gecos "" remoto_ssh`
- Permisos `.ssh`:
  - `sudo mkdir -p /home/remoto_ssh/.ssh`
  - `sudo chown remoto_ssh:remoto_ssh /home/remoto_ssh/.ssh`
  - `sudo chmod 700 /home/remoto_ssh/.ssh`
  - `sudo chmod 600 /home/remoto_ssh/.ssh/authorized_keys`
- Reiniciar SSH: `sudo systemctl restart ssh`

---

## 📸 Evidencias (añadir en `evidencias/`)
- `1_usuario_creado.png` — Usuario `remoto_ssh` creado
![imagenes](/ASO-UT4-Admin-Remota/capturas/ssh.png)
- `2_ssh_activo.png` — Servicio SSH activo
![imagenes](/ASO-UT4-Admin-Remota/capturas/ssh1.png)
- `3_claves_generadas.png` — PuTTYgen (clave pública/privada)
![imagenes](/ASO-UT4-Admin-Remota/capturas/ssh2.png)
- `limitar contraseñas` limitar contraseñas
![imagenes](/ASO-UT4-Admin-Remota/capturas/ssh3.png)
- `5_acceso_putty.png` — Acceso exitoso con `remoto_ssh`
![imagenes](/ASO-UT4-Admin-Remota/capturas/ssh4.png)

![imagenes](/ASO-UT4-Admin-Remota/capturas/ssh5.png)


