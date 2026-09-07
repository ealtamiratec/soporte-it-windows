# Análisis funcional de `Soporte-IT.bat`

## 1. Propósito general

`Soporte-IT.bat` es una **consola interactiva de diagnóstico, reparación, optimización y administración para Windows 11**. Centraliza herramientas nativas de Windows y WinGet en un menú ejecutado desde `cmd.exe`. El script no instala servicios propios ni permanece en segundo plano; cada acción se inicia cuando el operador selecciona una opción del menú.

El archivo contiene **707 líneas**, utiliza texto ASCII y terminadores de línea CRLF. Su versión interna es **3.0** y se identifica visualmente como una herramienta de **ALTAMIRATEC**.

| Dato técnico | Valor |
|---|---|
| Archivo principal | `Soporte-IT.bat` |
| Plataforma objetivo | Windows 11 |
| Intérprete | Símbolo del sistema de Windows (`cmd.exe`) |
| Privilegios | Administrador, solicitados mediante UAC |
| Interfaz | Menús de texto con `choice` |
| Registro de actividad | `%ProgramData%\AltamiraTec\Logs\admin_%COMPUTERNAME%.log` |
| Codificación del archivo analizado | ASCII |
| Terminadores de línea | CRLF |
| Tamaño | 19.937 bytes |
| SHA-256 del original analizado | `00a4eaf51fd17c538069fff71abaa6760b8f5c1772de77cad2516b650386d142` |

## 2. Inicialización y elevación de privilegios

Al comenzar, el script desactiva la impresión automática de comandos con `@echo off`, cambia el color de la consola a verde sobre negro, habilita las extensiones de comandos y la expansión retardada de variables, y establece como directorio de trabajo la carpeta donde se encuentra el propio archivo.

Para comprobar si la consola posee privilegios administrativos, ejecuta `fltmc.exe`. Si el comando devuelve un error, muestra un aviso y vuelve a lanzar el mismo archivo mediante PowerShell con `Start-Process -Verb RunAs`, lo que provoca la solicitud del Control de cuentas de usuario de Windows. La instancia sin privilegios finaliza después de solicitar la elevación.

Una vez elevado, asigna el título de la ventana, define los datos del autor, establece la carpeta de registros y crea `%ProgramData%\AltamiraTec\Logs` si todavía no existe. Finalmente, registra el inicio de la herramienta y muestra la pantalla de bienvenida.

## 3. Menú principal

El menú principal distribuye las funciones en siete módulos. La selección `0` registra el cierre, limpia la pantalla y finaliza el proceso.

| Opción | Módulo | Finalidad |
|---:|---|---|
| 1 | Información del sistema | Consultar datos del equipo, Windows, batería, pertenencia del dispositivo y reiniciar el sistema. |
| 2 | Reparación y mantenimiento | Ejecutar DISM, SFC y CHKDSK. |
| 3 | Optimización y limpieza | Optimizar unidades, abrir limpieza/almacenamiento y borrar temporales del usuario. |
| 4 | Administración de programas | Consultar, actualizar, desinstalar y exportar programas mediante WinGet. |
| 5 | Diagnóstico y reparación de red | Consultar red, probar destinos y restablecer DNS, Winsock o TCP/IP. |
| 6 | Consolas administrativas | Abrir catorce utilidades de administración de Windows. |
| 7 | Informe técnico | Consolidar diagnóstico del equipo en un archivo de texto en el Escritorio. |
| 0 | Salir | Registrar el cierre y terminar la herramienta. |

## 4. Información del sistema

Este módulo ofrece nueve operaciones. Las funciones de consulta muestran información o abren utilidades de Windows; el reinicio requiere confirmación antes de ejecutarse.

| Opción | Comando o componente | Comportamiento |
|---:|---|---|
| 1 | `systeminfo.exe` | Muestra el resumen del sistema operativo, hardware, revisiones, memoria y configuración general disponible para el comando. |
| 2 | `msinfo32.exe` | Abre la aplicación gráfica Información del sistema. |
| 3 | `mmc.exe fsmgmt.msc` | Abre Carpetas compartidas para consultar recursos, sesiones y archivos abiertos. Antes verifica que el complemento exista. |
| 4 | `cscript.exe slmgr.vbs /xpr` | Consulta si la activación de Windows es permanente o cuándo expira. |
| 5 | `winver.exe` | Abre el cuadro de versión y compilación de Windows. |
| 6 | `dsregcmd.exe /status` | Muestra el estado de unión del dispositivo y sus datos de registro o cuenta organizacional. |
| 7 | `powercfg.exe /batteryreport` | Genera `reporte_bateria.html` en `%USERPROFILE%\Desktop`. Comprueba el código de salida y la existencia del archivo. |
| 8 | PowerShell y `Get-CimInstance Win32_Battery` | Consulta nombre, estado, código de batería, carga restante y autonomía estimada. Si no existe batería, lo indica sin tratarlo como fallo. |
| 9 | `shutdown.exe /r /f /t 0` | Después de confirmar, reinicia inmediatamente y fuerza el cierre de aplicaciones. |
| 0 | Navegación interna | Regresa al menú principal. |

## 5. Reparación y mantenimiento de Windows

El módulo reúne herramientas de mantenimiento de la imagen de Windows, archivos protegidos y unidad del sistema. Las reparaciones de imagen y disco solicitan confirmación cuando pueden modificar el sistema o requerir programación para el siguiente reinicio.

| Opción | Comando | Acción |
|---:|---|---|
| 1 | `DISM /Online /Cleanup-Image /CheckHealth` | Comprueba rápidamente si la imagen de Windows está marcada como dañada y si el daño es reparable. |
| 2 | `DISM /Online /Cleanup-Image /ScanHealth` | Realiza un análisis más profundo del almacén de componentes. |
| 3 | `DISM /Online /Cleanup-Image /RestoreHealth` | Intenta reparar la imagen de Windows; exige confirmación previa. |
| 4 | `sfc /scannow` | Examina y repara archivos protegidos del sistema. |
| 5 | `DISM /Online /Cleanup-Image /StartComponentCleanup` | Elimina componentes reemplazados del almacén de componentes. |
| 6 | `chkdsk %SystemDrive% /scan` | Analiza en línea la unidad donde está instalado Windows. |
| 7 | `chkdsk %SystemDrive% /F` | Busca y repara errores lógicos; solicita confirmación y puede pedir programación para el próximo reinicio. |
| 0 | Navegación interna | Regresa al menú principal. |

## 6. Optimización y limpieza

Este módulo combina optimización de la unidad, acceso a herramientas gráficas y eliminación de archivos temporales del usuario actual.

| Opción | Comando | Acción |
|---:|---|---|
| 1 | `defrag %SystemDrive% /O` | Ejecuta la optimización apropiada para el tipo de unidad detectado por Windows. |
| 2 | `cleanmgr.exe` | Abre el Liberador de espacio en disco. |
| 3 | `del` y `rd` sobre `%TEMP%` | Después de confirmar, elimina archivos y subcarpetas temporales del usuario. Omite silenciosamente los elementos bloqueados o en uso. |
| 4 | `ms-settings:storagesense` | Abre la sección de almacenamiento de Configuración de Windows. |
| 0 | Navegación interna | Regresa al menú principal. |

## 7. Administración de programas con WinGet

Antes de mostrar el menú, el script verifica la existencia de `winget.exe` mediante `where.exe`. Si WinGet no está disponible, informa que se debe comprobar la instalación o actualización de App Installer y regresa al menú principal.

| Opción | Comando | Acción |
|---:|---|---|
| 1 | `winget list` | Enumera los programas que WinGet puede identificar en el equipo. |
| 2 | `winget upgrade` | Muestra las actualizaciones de aplicaciones disponibles. |
| 3 | `winget upgrade --all` | Tras confirmación, intenta actualizar todas las aplicaciones con actualización disponible. |
| 4 | `winget list` y `winget uninstall --exact` | Solicita un nombre o ID, muestra coincidencias y, tras confirmar, intenta desinstalar la coincidencia exacta. |
| 5 | `winget export --include-versions` | Exporta el inventario a `%USERPROFILE%\Desktop\WinGet_%COMPUTERNAME%.json`. |
| 0 | Navegación interna | Regresa al menú principal. |

## 8. Diagnóstico y reparación de red

El módulo permite consultar la configuración y las conexiones, diagnosticar destinos y restablecer componentes de la pila de red.

| Opción | Comando | Acción |
|---:|---|---|
| 1 | `ipconfig /all` | Muestra la configuración completa de los adaptadores de red. |
| 2 | `netstat -ano` | Lista conexiones y puertos, direcciones, estados y PID de los procesos asociados. |
| 3 | `tracert <destino>` | Solicita un host o dirección IP y rastrea la ruta hasta el destino. |
| 4 | `nslookup <dominio>` | Solicita un dominio y consulta su resolución DNS. |
| 5 | PowerShell `Test-NetConnection` | Solicita un host/IP y un puerto TCP para probar la conectividad. |
| 6 | `ncpa.cpl` | Abre la ventana de adaptadores y conexiones de red. |
| 7 | `ipconfig /flushdns` | Vacía la caché de resolución DNS local. |
| 8 | `netsh winsock reset` | Tras confirmación, restablece el catálogo Winsock. Normalmente requiere reiniciar para completar el efecto. |
| 9 | `netsh int ip reset` | Tras confirmación, restablece parámetros de la pila TCP/IP. Normalmente requiere reiniciar para completar el efecto. |
| 0 | Navegación interna | Regresa al menú principal. |

## 9. Consolas administrativas de Windows

Esta sección actúa como lanzador de herramientas integradas. El script no modifica directamente la configuración al abrirlas; las modificaciones posteriores dependen de lo que realice el operador dentro de cada consola.

| Opción | Componente | Herramienta abierta |
|---:|---|---|
| 1 | `control.exe` | Panel de control. |
| 2 | `msconfig.exe` | Configuración del sistema. |
| 3 | `taskmgr.exe` | Administrador de tareas. |
| 4 | `diskmgmt.msc` | Administración de discos. |
| 5 | `gpedit.msc` | Editor de directivas de grupo local. |
| 6 | `regedit.exe` | Editor del Registro. |
| 7 | `services.msc` | Consola de servicios. |
| 8 | `devmgmt.msc` | Administrador de dispositivos. |
| 9 | `perfmon.exe` | Monitor de rendimiento. |
| A | `eventvwr.msc` | Visor de eventos. |
| B | `dxdiag.exe` | Herramienta de diagnóstico de DirectX. |
| C | `netplwiz.exe` | Administración avanzada de cuentas de usuario. |
| D | `sysdm.cpl` | Propiedades del sistema. |
| E | `compmgmt.msc` | Administración de equipos. |
| 0 | Navegación interna | Regresa al menú principal. |

## 10. Generación del informe técnico

Antes de generar el informe, el script advierte que el documento puede contener nombres de usuario, direcciones IP y datos del equipo. Si el operador confirma, crea `%USERPROFILE%\Desktop\Diagnostico_%COMPUTERNAME%.txt` y agrega las siguientes secciones:

| Sección | Fuente | Contenido principal |
|---|---|---|
| Encabezado | Variables de entorno y fecha/hora | Nombre del equipo, usuario y momento de generación. |
| `SYSTEMINFO` | `systeminfo.exe` | Información general del sistema y del sistema operativo. |
| `IPCONFIG ALL` | `ipconfig.exe /all` | Configuración detallada de red. |
| `CONTROLADORES` | `driverquery.exe /FO TABLE` | Inventario tabular de controladores. |
| `SERVICIOS` | `sc.exe query type= service state= all` | Estado de todos los servicios. |
| `EVENTOS CRITICOS Y ERRORES DEL SISTEMA` | `wevtutil.exe qe System` | Los treinta eventos críticos o de error más recientes del registro Sistema. |

La salida estándar y los mensajes de error de cada comando se incorporan al mismo archivo, lo que permite conservar indicios de comandos no disponibles o fallidos.

## 11. Registro de actividad

La subrutina `LOG` agrega una línea por acción a `%ProgramData%\AltamiraTec\Logs\admin_%COMPUTERNAME%.log`. Cada línea incluye fecha, hora y una descripción breve, por ejemplo, el inicio de la herramienta, la ejecución de una operación o el cierre normal.

El registro **no captura la salida completa de los comandos** ni guarda explícitamente los destinos escritos en las consultas de red. Sin embargo, la ruta y el nombre del archivo revelan el nombre del equipo, y las marcas de tiempo muestran cuándo se ejecutaron acciones administrativas.

## 12. Archivos y cambios que puede producir

| Recurso | Operación | Persistencia |
|---|---|---|
| `%ProgramData%\AltamiraTec\Logs\` | Crea la carpeta de registros si no existe. | Persistente. |
| `admin_%COMPUTERNAME%.log` | Agrega entradas de auditoría de uso. | Persistente y acumulativo. |
| `reporte_bateria.html` | Genera un informe de batería en el Escritorio. | Persistente hasta que el usuario lo elimine. |
| `WinGet_%COMPUTERNAME%.json` | Exporta un inventario de aplicaciones. | Persistente hasta que el usuario lo elimine. |
| `Diagnostico_%COMPUTERNAME%.txt` | Genera un informe técnico con datos del sistema y la red. | Persistente hasta que el usuario lo elimine. |
| `%TEMP%` del usuario | Elimina archivos y subdirectorios que no estén bloqueados. | Cambio destructivo para los temporales eliminados. |
| Imagen, archivos protegidos y componentes de Windows | Puede analizar, reparar o limpiar mediante DISM y SFC. | Puede modificar componentes del sistema. |
| Unidad del sistema | Puede analizar, optimizar o reparar mediante CHKDSK y `defrag`. | Puede modificar metadatos del sistema de archivos o la disposición/optimización de la unidad. |
| Aplicaciones administradas por WinGet | Puede actualizar o desinstalar paquetes. | Cambio persistente en el software instalado. |
| Winsock y TCP/IP | Puede restablecer la configuración. | Cambio persistente; puede requerir reinicio. |
| Sesión de Windows | Puede reiniciar inmediatamente el equipo. | Cierra aplicaciones de forma forzada y reinicia. |

## 13. Controles de seguridad y confirmación incorporados

El script requiere elevación administrativa al inicio y solicita confirmación antes de ejecutar el reinicio, la reparación DISM, CHKDSK con `/F`, la limpieza de temporales, la actualización masiva, la desinstalación, el restablecimiento de Winsock, el restablecimiento de TCP/IP y la generación del informe técnico.

No obstante, otras operaciones administrativas, como `sfc /scannow`, la limpieza de componentes, la optimización de la unidad y el vaciado de la caché DNS, se ejecutan inmediatamente después de seleccionarlas. Por ello, debe utilizarse por personal que comprenda los efectos de cada comando.

## 14. Limitaciones y observaciones técnicas

El script está orientado a Windows 11 y depende de componentes que pueden variar según la edición o configuración del sistema. `gpedit.msc` y algunos complementos administrativos pueden no estar disponibles en todas las ediciones; WinGet depende de App Installer; los informes se guardan en la ruta literal `%USERPROFILE%\Desktop`, que puede no coincidir con el Escritorio real cuando la carpeta fue redirigida, localizada o administrada por OneDrive.

La elevación construye un comando de PowerShell con la ruta del BAT entre comillas simples. Una ruta que contenga un apóstrofo podría impedir el relanzamiento. El módulo de desinstalación acepta un nombre o ID introducido por el operador y utiliza coincidencia exacta, pero conviene revisar cuidadosamente el resultado mostrado antes de confirmar.

Los informes y exportaciones pueden incluir **información sensible o identificable**, como nombres de usuario y equipo, direcciones IP, direcciones MAC, nombres de adaptadores, software instalado, controladores, servicios y eventos. Estos archivos no deben publicarse en GitHub sin revisión y anonimización previa.

## 15. Flujo de finalización

Al escoger `0` en el menú principal, el script registra el mensaje `Cierre de la herramienta`, limpia la consola, muestra una pantalla de finalización, ejecuta `endlocal` y devuelve el código de salida `0`. Si se ordena un reinicio inmediato, finaliza después de llamar a `shutdown.exe`.
