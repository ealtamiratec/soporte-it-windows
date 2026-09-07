# Soporte IT para Windows 11

**Soporte-IT** es una consola administrativa interactiva en formato Batch que reúne tareas habituales de diagnóstico, reparación, mantenimiento, optimización, administración de programas y soporte de red para equipos con Windows 11.

La herramienta utiliza comandos y consolas integrados en Windows, además de WinGet cuando se encuentra disponible. Al iniciarse, comprueba los privilegios y solicita elevación mediante el Control de cuentas de usuario (UAC), ya que varias operaciones requieren permisos administrativos.

> [!WARNING]
> Este script puede modificar componentes de Windows, eliminar archivos temporales, actualizar o desinstalar aplicaciones, restablecer la configuración de red y reiniciar el equipo de manera forzada. Revise cada opción, guarde su trabajo y utilícelo únicamente en equipos autorizados.

## Características

| Módulo | Funciones principales |
|---|---|
| Información del sistema | Muestra información del equipo, abre `msinfo32`, consulta activación y versión de Windows, revisa el estado de unión del dispositivo, genera un informe de batería y permite reiniciar. |
| Reparación y mantenimiento | Ejecuta comprobaciones y reparaciones mediante DISM, SFC y CHKDSK. Microsoft documenta DISM y SFC como herramientas integradas para restaurar componentes y archivos de sistema dañados.[1] |
| Optimización y limpieza | Optimiza la unidad del sistema, abre el Liberador de espacio, elimina temporales del usuario y abre la configuración de almacenamiento. |
| Administración de programas | Usa WinGet para listar aplicaciones, consultar actualizaciones, actualizar paquetes, desinstalar una coincidencia exacta y exportar el inventario. WinGet forma parte de App Installer en Windows de escritorio.[2] |
| Diagnóstico y reparación de red | Muestra la configuración y conexiones, ejecuta `tracert`, `nslookup` y `Test-NetConnection`, vacía DNS y restablece Winsock o TCP/IP. |
| Consolas administrativas | Abre Panel de control, Configuración del sistema, Administrador de tareas, Administración de discos, Directivas de grupo, Registro, Servicios y otras consolas. |
| Informe técnico | Genera un archivo de texto con sistema, red, controladores, servicios y los eventos críticos o de error más recientes. |

La descripción detallada de todas las opciones, comandos, rutas y efectos se encuentra en [`docs/ANALISIS_FUNCIONAL.md`](docs/ANALISIS_FUNCIONAL.md).

## Requisitos

| Componente | Requisito |
|---|---|
| Sistema operativo | Windows 11. |
| Permisos | Cuenta con capacidad de aprobar la elevación UAC. |
| Intérprete | `cmd.exe`, PowerShell y utilidades administrativas estándar de Windows. |
| WinGet | Opcional; necesario únicamente para el módulo de programas. |
| Internet | Recomendado para las reparaciones que consulten Windows Update y para las actualizaciones administradas por WinGet. |
| Respaldo | Recomendado antes de usar reparación de disco, actualizaciones masivas, desinstalación o restablecimiento de red. |

CHKDSK con `/f` corrige errores y puede solicitar que la operación se programe para el siguiente reinicio si la unidad no puede bloquearse.[3] El restablecimiento de TCP/IP sobrescribe parámetros de red y Microsoft indica reiniciar el equipo después de ejecutarlo.[4]

## Instalación

No requiere un instalador. Descargue `Soporte-IT.bat` desde la sección **Releases** o clone el repositorio:

```powershell
git clone https://github.com/ealtamiratec/soporte-it-windows.git
cd soporte-it-windows
```

Antes de ejecutarlo, revise el contenido y, si el archivo se descargó desde Internet, compruebe sus propiedades y el aviso de seguridad de Windows. La versión analizada para preparar este repositorio tiene el siguiente hash:

```text
SHA-256: 00a4eaf51fd17c538069fff71abaa6760b8f5c1772de77cad2516b650386d142
```

La URL propuesta utiliza la cuenta conectada **`ealtamiratec`** y el nombre de repositorio recomendado **`soporte-it-windows`**.

## Uso

Ejecute el archivo con doble clic o desde una consola:

```bat
Soporte-IT.bat
```

Windows mostrará una solicitud UAC. Después de aprobarla, seleccione una opción del menú principal y siga las confirmaciones en pantalla. Para las tareas prolongadas, como DISM, SFC, CHKDSK o actualizaciones masivas, mantenga el equipo conectado a la alimentación y no cierre la consola antes de que termine el proceso. Microsoft recomienda ejecutar DISM antes de SFC cuando se reparan archivos del sistema.[1]

## Archivos generados

| Archivo o ruta | Contenido |
|---|---|
| `%ProgramData%\AltamiraTec\Logs\admin_%COMPUTERNAME%.log` | Fecha, hora y nombre de cada acción iniciada desde la herramienta. |
| `%USERPROFILE%\Desktop\reporte_bateria.html` | Informe HTML generado mediante `powercfg /batteryreport`; Microsoft admite el parámetro `/output` para especificar el destino.[5] |
| `%USERPROFILE%\Desktop\WinGet_%COMPUTERNAME%.json` | Inventario exportado por WinGet con versiones. |
| `%USERPROFILE%\Desktop\Diagnostico_%COMPUTERNAME%.txt` | Sistema, red, controladores, servicios y eventos críticos o de error. |

> [!IMPORTANT]
> Los informes pueden contener nombres de usuario y equipo, direcciones IP y MAC, adaptadores, software instalado, controladores, servicios y eventos. **No publique informes reales sin revisarlos y anonimizarlos.**

## Operaciones de mayor impacto

| Operación | Efecto o precaución |
|---|---|
| Limpiar `%TEMP%` | Elimina archivos y carpetas temporales que no estén bloqueados. Cierre aplicaciones antes de usarla. |
| `DISM /RestoreHealth` | Repara la imagen de Windows y puede obtener archivos desde Windows Update.[1] |
| `DISM /StartComponentCleanup` | Elimina componentes reemplazados del almacén de componentes. |
| `chkdsk /F` | Corrige errores del sistema de archivos y puede ejecutarse durante el siguiente reinicio.[3] |
| `winget upgrade --all` | Actualiza de forma masiva los paquetes compatibles detectados por WinGet.[2] |
| `winget uninstall --exact` | Desinstala la coincidencia exacta confirmada por el operador. |
| `netsh winsock reset` | Restablece Winsock y puede requerir reinicio. |
| `netsh int ip reset` | Restablece parámetros TCP/IP y requiere privilegios administrativos.[4] |
| `shutdown /r /f /t 0` | Reinicia inmediatamente y fuerza el cierre de aplicaciones; puede perderse trabajo no guardado. |

La evaluación completa de riesgos, privacidad y limitaciones se encuentra en [`docs/SEGURIDAD_Y_REQUISITOS.md`](docs/SEGURIDAD_Y_REQUISITOS.md).

## Estructura del repositorio

```text
soporte-it-windows/
├── .github/
│   └── ISSUE_TEMPLATE/
├── docs/
│   ├── ANALISIS_FUNCIONAL.md
│   ├── SEGURIDAD_Y_REQUISITOS.md
│   └── VALIDACION.md
├── .gitattributes
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── SECURITY.md
└── Soporte-IT.bat
```

## Compatibilidad y limitaciones

La ruta de exportación está codificada como `%USERPROFILE%\Desktop`. Si el Escritorio está redirigido por OneDrive, una directiva corporativa o una configuración localizada, la exportación puede fallar o guardarse en una carpeta distinta de la que el usuario espera.

Algunas consolas, especialmente `gpedit.msc`, pueden no estar disponibles en todas las ediciones de Windows. El script valida la presencia de WinGet y de `fsmgmt.msc`, pero no comprueba individualmente todos los demás componentes.

## Seguridad del código

La revisión realizada fue estática y no ejecutó el BAT. No se encontraron instrucciones para descargar y ejecutar contenido remoto, instalar persistencia, recolectar credenciales, desactivar controles de seguridad ni enviar información a servicios externos. Sin embargo, el archivo sí incorpora operaciones administrativas de alto impacto, por lo que debe probarse en una máquina virtual o equipo de laboratorio antes de utilizarse en producción.

## Datos de autoría antes de publicar

El BAT no incluye datos personales de contacto. Mantenga cualquier correo de soporte o información del autor fuera del script, salvo que exista una decisión explícita de publicarlos.

## Contribuciones y reportes de seguridad

Las propuestas de mejora deben seguir [`CONTRIBUTING.md`](CONTRIBUTING.md). Las vulnerabilidades o problemas que puedan causar pérdida de datos no deben publicarse inicialmente como una incidencia abierta; utilice el proceso descrito en [`SECURITY.md`](SECURITY.md).

## Licencia

Este proyecto se distribuye bajo la [MIT License](LICENSE), una licencia gratuita y permisiva reconocida por GitHub. Permite usar, copiar, modificar y redistribuir el código, incluso con fines comerciales, siempre que se conserve el aviso de copyright y la licencia. El software se proporciona sin garantía; consulte el texto completo en [`LICENSE`](LICENSE).

## Referencias

[1]: https://support.microsoft.com/es-es/windows/experience/backup-recovery/use-the-system-file-checker-tool-to-repair-missing-or-corrupted-system-files "Use la herramienta Comprobador de archivos de sistema — Microsoft Support"
[2]: https://learn.microsoft.com/en-us/windows/package-manager/winget/ "Use WinGet to install and manage applications — Microsoft Learn"
[3]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/chkdsk "chkdsk — Microsoft Learn"
[4]: https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/reset-tcp-ip-net-shell "Reset TCP/IP by Using the NetShell Utility — Microsoft Learn"
[5]: https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/powercfg-command-line-options "Powercfg command-line options — Microsoft Learn"
