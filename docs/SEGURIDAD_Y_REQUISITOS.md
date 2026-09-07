# Seguridad, requisitos y condiciones de uso

## Alcance de la evaluación

Esta evaluación es **estática**: se revisó el contenido de `Soporte-IT.bat` sin ejecutarlo. El archivo invoca exclusivamente comandos y componentes esperados de Windows, además de WinGet cuando está disponible. No se observaron instrucciones para descargar y ejecutar contenido remoto, crear persistencia, recolectar credenciales, evadir controles de seguridad ni transmitir información por Internet.

> **Advertencia:** que un script no presente patrones maliciosos no significa que todas sus operaciones sean inocuas. Este archivo puede reparar componentes, borrar temporales, actualizar o desinstalar aplicaciones, restablecer la red y reiniciar el equipo.

## Requisitos

| Requisito | Estado | Observación |
|---|---|---|
| Windows 11 | Obligatorio según el alcance declarado | Algunos comandos también existen en otras versiones, pero el archivo se presenta y documenta específicamente para Windows 11. |
| `cmd.exe` y componentes nativos | Obligatorio | El script depende de herramientas incluidas en Windows, como DISM, SFC, CHKDSK, PowerShell, `netsh` y consolas MMC. |
| Privilegios administrativos | Obligatorio | El archivo intenta elevarse automáticamente mediante UAC. Microsoft exige una consola elevada para las operaciones de reparación y administración más sensibles.[1] [2] [5] |
| WinGet/App Installer | Condicional | Solo se necesita para el módulo de programas. El script detecta si `winget.exe` está disponible. Microsoft distribuye WinGet como parte de App Installer en Windows de escritorio.[3] |
| Conexión a Internet | Condicional | Puede ser necesaria para `DISM /RestoreHealth` cuando utiliza Windows Update y para consultar/descargar actualizaciones con WinGet.[1] |
| Escritorio accesible en `%USERPROFILE%\Desktop` | Requerido para exportaciones | Los tres archivos exportables usan esta ruta literal. Puede fallar si el Escritorio está redirigido a OneDrive, a una ubicación corporativa o a una ruta localizada diferente. |
| Copia de seguridad y cierre de aplicaciones | Recomendado | Es especialmente importante antes de CHKDSK con reparación, cambios de red, actualizaciones masivas o reinicio forzado. |

## Matriz de riesgos operativos

| Acción | Nivel | Riesgo principal | Control actual | Recomendación |
|---|---|---|---|---|
| Consultas de sistema, red y batería | Bajo | Exposición visual de datos del equipo. | El resultado normalmente solo se muestra en consola. | Evitar capturas o compartir salidas sin revisión. |
| Apertura de consolas administrativas | Medio | El operador puede realizar cambios fuera del control del BAT. | El script únicamente abre la consola. | Limitar su uso a personal autorizado. |
| `DISM /RestoreHealth` y `sfc /scannow` | Medio | Cambios en componentes y archivos protegidos; operación prolongada. | DISM solicita confirmación; SFC no. | No interrumpir los procesos y revisar sus resultados.[1] |
| `DISM /StartComponentCleanup` | Medio | Elimina componentes reemplazados y puede dificultar ciertas operaciones de reversión. | No solicita confirmación. | Añadir confirmación en una versión futura. |
| `chkdsk /F` | Alto | Modificación del sistema de archivos; puede programarse para el reinicio y tardar considerablemente. | Solicita confirmación; CHKDSK solicita programación si no puede bloquear la unidad. | Tener respaldo, alimentación estable y no interrumpir la reparación.[2] |
| Optimización de la unidad | Bajo/medio | Consumo temporal de E/S y rendimiento. | Windows selecciona el método de optimización con `/O`. | Ejecutar fuera de horas críticas. |
| Limpieza de `%TEMP%` | Medio | Eliminación irreversible de temporales que alguna aplicación podría necesitar. | Solicita confirmación y omite archivos bloqueados. | Cerrar aplicaciones y validar que `%TEMP%` sea la ruta esperada. |
| `winget upgrade --all` | Alto | Cambios masivos de versiones, posibles incompatibilidades o solicitudes interactivas. | Solicita confirmación. | Revisar primero `winget upgrade` y disponer de copias/configuraciones recuperables.[3] |
| `winget uninstall --exact` | Alto | Desinstalación de la aplicación equivocada si el nombre o ID no se verifica cuidadosamente. | Muestra `winget list` y solicita confirmación. | Preferir el ID inequívoco del paquete y revisar la coincidencia. |
| Restablecimiento de Winsock | Alto | Pérdida temporal de conectividad o necesidad de reinicio. | Solicita confirmación. | Registrar configuraciones especiales antes de ejecutarlo. |
| Restablecimiento TCP/IP | Alto | Sobrescribe parámetros de TCP/IP en el Registro y requiere reinicio para completar el procedimiento documentado. | Solicita confirmación. | Respaldar la configuración de red y prever acceso local al equipo.[5] |
| Reinicio `/r /f /t 0` | Crítico | Cierre forzado de aplicaciones y posible pérdida de trabajo no guardado. | Solicita confirmación. | Guardar todo el trabajo; considerar retirar `/f` o usar una cuenta regresiva. |
| Informe técnico | Alto para privacidad | Puede contener usuario, equipo, IP, MAC, adaptadores, software, controladores, servicios y eventos. | Advierte sobre datos sensibles y solicita confirmación. | Anonimizar antes de compartir; nunca adjuntar informes reales al repositorio. |

## Privacidad y datos personales

El BAT no incluye nombre completo, correo electrónico ni número telefónico. Esta decisión evita exponer datos personales en una publicación pública; cualquier canal de contacto debe definirse mediante la configuración del repositorio.

Antes de publicar se recomienda decidir expresamente si esos datos deben permanecer. Para un proyecto público suele ser preferible usar un correo profesional destinado al proyecto y omitir el teléfono personal. Si se modifica esta información después de un primer `commit`, la eliminación del archivo actual no borra las versiones históricas; por ello, la revisión debe realizarse **antes del primer envío público**.

Los informes generados por la herramienta también contienen datos que no deben entrar al control de versiones. El archivo `.gitignore` del paquete excluye los patrones conocidos de reportes y registros, pero esa medida no sustituye la revisión manual.

## Limitaciones detectadas

| Limitación | Consecuencia | Mejora sugerida |
|---|---|---|
| El Escritorio se representa como `%USERPROFILE%\Desktop`. | Las exportaciones pueden fallar cuando la carpeta está redirigida o localizada. | Resolver la ubicación mediante Known Folders o PowerShell antes de exportar. |
| No se comprueba la disponibilidad de todas las consolas. | `gpedit.msc` y otros complementos pueden no existir en ciertas ediciones. | Validar `if exist` o `where` y mostrar un mensaje específico. |
| La mayoría de comandos no validan `errorlevel`. | El registro refleja que una acción se inició, pero no necesariamente que terminó correctamente. | Registrar inicio, código de salida, resultado y duración. |
| El informe técnico siempre muestra un mensaje final de éxito. | Puede haber secciones con errores redirigidos dentro del archivo. | Evaluar el resultado de cada comando y producir un resumen de estado. |
| El relanzamiento elevado inserta la ruta del BAT entre comillas simples de PowerShell. | Una ruta que contenga un apóstrofo puede romper el comando de elevación. | Escapar comillas simples o usar una técnica de elevación que pase la ruta como argumento seguro. |
| Las acciones largas no muestran una estimación ni impiden el cierre accidental. | El usuario podría interpretar una espera prolongada como bloqueo. | Añadir mensajes de progreso y advertencias de no interrupción. |
| El reinicio usa `/f` y tiempo `0`. | Puede perderse trabajo no guardado. | Ofrecer reinicio normal, cuenta regresiva y opción de cancelar. |
| No existe un modo de solo diagnóstico. | Una selección equivocada puede iniciar una acción correctiva. | Separar modos de consulta y reparación o exigir una confirmación global para cambios. |
| No existe un canal de contacto específico para el proyecto. | Los reportes pueden llegar a canales personales o quedar sin seguimiento. | Configurar Issues y Private vulnerability reporting en GitHub antes de publicar. |

## Recomendaciones previas a la publicación

Para una publicación responsable, se debe probar el archivo en una **máquina virtual de Windows 11** o en un equipo de laboratorio, ejecutar cada opción de consulta y validar las opciones destructivas sobre una instantánea recuperable. Conviene comprobar, como mínimo, Windows 11 Home y Pro, equipos con y sin batería, WinGet presente y ausente, Escritorio local y redirigido, y una ruta del BAT que contenga espacios.

Antes de publicar, configure un canal de contacto del proyecto en GitHub y revise que no se incorporen datos personales en nuevos cambios.

## Referencias

[1]: https://support.microsoft.com/es-es/windows/experience/backup-recovery/use-the-system-file-checker-tool-to-repair-missing-or-corrupted-system-files "Use la herramienta Comprobador de archivos de sistema — Microsoft Support"
[2]: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/chkdsk "chkdsk — Microsoft Learn"
[3]: https://learn.microsoft.com/en-us/windows/package-manager/winget/ "Use WinGet to install and manage applications — Microsoft Learn"
[4]: https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/powercfg-command-line-options "Powercfg command-line options — Microsoft Learn"
[5]: https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/reset-tcp-ip-net-shell "Reset TCP/IP by Using the NetShell Utility — Microsoft Learn"
