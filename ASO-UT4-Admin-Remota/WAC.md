# Infraestructura

## Servidores
- **Windows Server 2025** (servidor)
- **Ubuntu Server 24.04** (servidor)

## Equipo Administrador
- **Windows 11** (equipo administrador)

## Red
- **Red privada**  

Todas las conexiones se realizan desde el navegador del Windows 11.

---

# PARTE 1 – WINDOWS ADMIN CENTER (WAC)

## Herramienta
- **Windows Admin Center**

## Protocolo
- **HTTPS**

## Puerto
- **El configurado en el sistema**

## Instalación de WAC:

![imagen](/ASO-UT4-Admin-Remota/capturas/imagen.png)

![imagen](/ASO-UT4-Admin-Remota/capturas/imagen1.png)
 
1.	Acceso a Windows Admin Center con https://localhost:PUERTO, 
 
![imagen](/ASO-UT4-Admin-Remota/capturas/imagen2.png)

Añadimos el dominio poniendo la ip de este mismo.

 ![imagen](/ASO-UT4-Admin-Remota/capturas/imagen3.png)

2.	Ahora vemos la informacion del servidor

- **Ver información del sistema**

 ![imagen](/ASO-UT4-Admin-Remota/capturas/imagen4.png)
 
- **Monitorizar CPU y memoria**
 
  ![imagen](/ASO-UT4-Admin-Remota/capturas/imagen5.png)

- **Acceder a servicios o eventos**
 
  ![imagen](/ASO-UT4-Admin-Remota/capturas/imagen6.png)


- **Documentación técnica WAC**. En el README.md de la práctica, incluir una tabla con la información:
| Sistema administrado | Herramienta | Protocolo | Puerto |
|----------------------|-------------|-----------|--------|
| Windows server       | Windowsadmincenter | udp       | 6600   |



## PARTE 2 – Cockpit (Linux)
Herramienta: Cockpit
Servicio: cockpit
Protocolo: HTTPS

1.	Comprobación del servicio Cockpit despues de instalarlo

 ![imagen](/ASO-UT4-Admin-Remota/capturas/imagen7.png)

 
2.	Creación de usuario remoto para administración del Cockpit.
 
 ![imagen](/ASO-UT4-Admin-Remota/capturas/imagen8.png)

3.	Acceso remoto desde Windows 11 https://IP_DEL_UBUNTU:PUERTO.

 ![imagen](/ASO-UT4-Admin-Remota/capturas/imagen9.png)
 
Comprobar que es posible monitorizar el sistema 

- **Servicio Cockpit**. Captura del estado del servicio y del socket de Cockpit.

 ![imagen](/ASO-UT4-Admin-Remota/capturas/imagen10.png)

 Este no carga debido a los bajos recursos de mi equipo host (tengo 4 maquinas a la vez abiertas)
 
- **Usuario remoto creado**. Captura que demuestre la existencia del usuario remoto.
 
 ![imagen](/ASO-UT4-Admin-Remota/capturas/imagen11.png)

- **URL, interfaz de Cockpit, usuario conectado.**
 
 ![imagen](/ASO-UT4-Admin-Remota/capturas/imagen9.png)

- **Información real del sistema** (CPU y memoria).

 ![imagen](/ASO-UT4-Admin-Remota/capturas/imagen12.png)

- **Documentación técnica Cockpit**. En el README.md, incluir la siguiente tabla:
| Sistema | Usuario remoto | Herramienta | Protocolo | Puerto |
|---------|----------------|-------------|-----------|--------|
| UbuntuServer | cockpit         | cockpit      | tcp       | 9090   |





