@echo off
color 0A
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"

:: ============================================================================
:: ALTAMIRATEC - HERRAMIENTAS ADMINISTRATIVAS PARA WINDOWS 11
:: Version 1.0.0 - Soporte tecnico
:: Todo el texto del BAT utiliza caracteres ASCII sin tildes.
:: ============================================================================

:: Comprobar si CMD tiene privilegios administrativos.
"%SystemRoot%\System32\fltmc.exe" >nul 2>&1
if errorlevel 1 goto SOLICITAR_ADMIN

goto CONFIGURAR

:SOLICITAR_ADMIN
cls
echo.
echo  ============================================================================
echo   ALTAMIRATEC - SE REQUIEREN PERMISOS DE ADMINISTRADOR
echo  ============================================================================
echo.
echo   Windows mostrara una solicitud de Control de cuentas de usuario UAC.
echo.
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
exit /b

:CONFIGURAR
title ALTAMIRATEC - HERRAMIENTAS DE SOPORTE WINDOWS 11
color 0A

set "LOGDIR=%ProgramData%\AltamiraTec\Logs"
set "LOGFILE=%LOGDIR%\admin_%COMPUTERNAME%.log"

if not exist "%LOGDIR%" md "%LOGDIR%" >nul 2>&1
call :LOG "Inicio de la herramienta"

goto INICIO

:INICIO
cls
call :ENCABEZADO
echo   CONSOLA DE SOPORTE TECNICO PARA WINDOWS 11
echo  ------------------------------------------------------------------------------
echo.
echo.
echo   Herramientas de diagnostico, reparacion y administracion.
echo.
echo   Presione una tecla para abrir el menu principal.
echo.
pause >nul
goto MENU

:MENU
cls
call :ENCABEZADO
echo   MENU PRINCIPAL
echo  ------------------------------------------------------------------------------
echo.
echo   [1] Informacion del Sistema
echo   [2] Reparacion y Mantenimiento de Windows
echo   [3] Optimizacion y Limpieza
echo   [4] Administracion de Programas
echo   [5] Diagnostico y Reparacion de Red
echo   [6] Consolas Administrativas de Windows
echo   [7] Generar Informe Tecnico en el Escritorio
echo   [0] Salir
echo.
echo  ------------------------------------------------------------------------------
choice /C 12345670 /N /M "  Seleccione una opcion [0-7]: "
goto MENU_%errorlevel%

:MENU_1
goto INFO
:MENU_2
goto MANTENIMIENTO
:MENU_3
goto OPTIMIZACION
:MENU_4
goto WINGET
:MENU_5
goto RED
:MENU_6
goto ADMIN
:MENU_7
goto INFORME
:MENU_8
goto SALIR

:: ============================================================================
:: 1. INFORMACION DEL SISTEMA
:: ============================================================================
:INFO
cls
call :ENCABEZADO
echo   RUTA: MENU PRINCIPAL ^> [1] INFORMACION DEL SISTEMA
echo  ------------------------------------------------------------------------------
echo.
echo   [1] Resumen del sistema
echo   [2] Informacion avanzada
echo   [3] Carpetas compartidas, sesiones y archivos
echo   [4] Estado de activacion de Windows
echo   [5] Version de Windows
echo   [6] Estado de union y cuenta del dispositivo
echo   [7] Exportar informe de bateria al Escritorio
echo   [8] Consultar estado actual de la bateria
echo   [9] Reiniciar el equipo
echo   [0] Volver al menu principal
echo.

echo  ------------------------------------------------------------------------------
choice /C 1234567890 /N /M "  Seleccione una opcion [0-9]: "
goto INFO_%errorlevel%

:INFO_1
call :LOG "Ejecutar systeminfo"
cls
systeminfo.exe
call :PAUSA
goto INFO

:INFO_2
call :LOG "Abrir msinfo32.exe"
start "" "%SystemRoot%\System32\msinfo32.exe"
goto INFO

:INFO_3
call :LOG "Abrir fsmgmt.msc"
if exist "%SystemRoot%\System32\fsmgmt.msc" goto INFO_3_ABRIR
cls
call :ENCABEZADO
echo   ERROR: No se encontro el archivo:
echo   %SystemRoot%\System32\fsmgmt.msc
echo.
echo   Esta consola puede no estar disponible en la edicion instalada de Windows.
call :PAUSA
goto INFO

:INFO_3_ABRIR
start "" "%SystemRoot%\System32\mmc.exe" "%SystemRoot%\System32\fsmgmt.msc"
goto INFO

:INFO_4
call :LOG "Consultar activacion de Windows"
cscript.exe //nologo "%SystemRoot%\System32\slmgr.vbs" /xpr
call :PAUSA
goto INFO

:INFO_5
call :LOG "Abrir winver.exe"
start "" "%SystemRoot%\System32\winver.exe"
goto INFO

:INFO_6
call :LOG "Ejecutar dsregcmd status"
cls
dsregcmd.exe /status
call :PAUSA
goto INFO

:INFO_7
cls
call :ENCABEZADO
echo   EXPORTAR INFORME DE BATERIA
echo  ------------------------------------------------------------------------------
echo.
call :LOG "Exportar informe de bateria"
powercfg.exe /batteryreport /output "%USERPROFILE%\Desktop\reporte_bateria.html"
if errorlevel 1 goto INFO_7_ERROR
if not exist "%USERPROFILE%\Desktop\reporte_bateria.html" goto INFO_7_ERROR
echo.
echo   Informe generado correctamente en:
echo   %USERPROFILE%\Desktop\reporte_bateria.html
call :PAUSA
goto INFO

:INFO_7_ERROR
echo.
echo   No fue posible generar el informe de bateria.
echo   Verifique que la carpeta Escritorio este disponible.
call :PAUSA
goto INFO

:INFO_8
cls
call :ENCABEZADO
echo   ESTADO ACTUAL DE LA BATERIA
echo  ------------------------------------------------------------------------------
echo.
call :LOG "Consultar estado actual de bateria"
powershell.exe -NoProfile -Command "$b = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue; if ($null -eq $b) { Write-Host 'No se detecto una bateria en este equipo.'; exit 0 }; $b | Format-List Name,Status,BatteryStatus,EstimatedChargeRemaining,EstimatedRunTime"
if errorlevel 1 goto INFO_8_ERROR
call :PAUSA
goto INFO

:INFO_8_ERROR
echo.
echo   No fue posible consultar la informacion de la bateria.
call :PAUSA
goto INFO

:INFO_9
cls
call :ENCABEZADO
echo   REINICIO DEL EQUIPO
echo  ------------------------------------------------------------------------------
echo.
choice /C SN /N /M "  Confirma el reinicio inmediato? [S/N]: "
if errorlevel 2 goto INFO
call :LOG "Reinicio inmediato solicitado"
shutdown.exe /r /f /t 0
exit /b

:INFO_10
goto MENU

:: ============================================================================
:: 2. REPARACION Y MANTENIMIENTO
:: ============================================================================
:MANTENIMIENTO
cls
call :ENCABEZADO
echo   REPARACION Y MANTENIMIENTO DE WINDOWS
echo  ------------------------------------------------------------------------------
echo.
echo   [1] Comprobacion rapida de la imagen de Windows
echo   [2] Analisis completo de la imagen de Windows
echo   [3] Reparar la imagen de Windows
echo   [4] Verificar y reparar archivos protegidos
echo   [5] Limpiar componentes reemplazados
echo   [6] Analizar la unidad del sistema en linea
echo   [7] Reparar errores de la unidad del sistema
echo   [0] Volver al menu principal
echo.
echo  ------------------------------------------------------------------------------
choice /C 12345670 /N /M "  Seleccione una opcion [0-7]: "
goto MANT_%errorlevel%

:MANT_1
call :LOG "DISM CheckHealth"
DISM.exe /Online /Cleanup-Image /CheckHealth
call :PAUSA
goto MANTENIMIENTO

:MANT_2
call :LOG "DISM ScanHealth"
DISM.exe /Online /Cleanup-Image /ScanHealth
call :PAUSA
goto MANTENIMIENTO

:MANT_3
cls
call :ENCABEZADO
echo   DISM RESTOREHEALTH
echo  ------------------------------------------------------------------------------
echo.
choice /C SN /N /M "  Confirma que desea reparar la imagen de Windows? [S/N]: "
if errorlevel 2 goto MANTENIMIENTO
call :LOG "DISM RestoreHealth"
DISM.exe /Online /Cleanup-Image /RestoreHealth
call :PAUSA
goto MANTENIMIENTO

:MANT_4
call :LOG "SFC scannow"
sfc.exe /scannow
call :PAUSA
goto MANTENIMIENTO

:MANT_5
call :LOG "DISM StartComponentCleanup"
DISM.exe /Online /Cleanup-Image /StartComponentCleanup
call :PAUSA
goto MANTENIMIENTO

:MANT_6
call :LOG "CHKDSK scan"
chkdsk.exe %SystemDrive% /scan
call :PAUSA
goto MANTENIMIENTO

:MANT_7
cls
call :ENCABEZADO
echo   CHKDSK CON REPARACION
echo  ------------------------------------------------------------------------------
echo.
echo   Puede solicitar programar la comprobacion para el siguiente reinicio.
echo.
choice /C SN /N /M "  Confirma CHKDSK %SystemDrive% /F? [S/N]: "
if errorlevel 2 goto MANTENIMIENTO
call :LOG "CHKDSK F"
chkdsk.exe %SystemDrive% /F
call :PAUSA
goto MANTENIMIENTO

:MANT_8
goto MENU

:: ============================================================================
:: 3. OPTIMIZACION Y LIMPIEZA
:: ============================================================================
:OPTIMIZACION
cls
call :ENCABEZADO
echo   OPTIMIZACION Y LIMPIEZA
echo  ------------------------------------------------------------------------------
echo.
echo   [1] Optimizar la unidad del sistema
echo   [2] Abrir Liberador de espacio
echo   [3] Limpiar temporales del usuario actual
echo   [4] Abrir Configuracion de almacenamiento
echo   [0] Volver al menu principal
echo.
echo  ------------------------------------------------------------------------------
choice /C 12340 /N /M "  Seleccione una opcion [0-4]: "
goto OPT_%errorlevel%

:OPT_1
call :LOG "Optimizar unidad del sistema"
defrag.exe %SystemDrive% /O
call :PAUSA
goto OPTIMIZACION

:OPT_2
call :LOG "Abrir cleanmgr"
start "" cleanmgr.exe
goto OPTIMIZACION

:OPT_3
cls
call :ENCABEZADO
echo   LIMPIEZA DE TEMPORALES DEL USUARIO
echo  ------------------------------------------------------------------------------
echo.
echo   Los archivos en uso no se eliminaran.
echo.
choice /C SN /N /M "  Confirma la limpieza de %TEMP%? [S/N]: "
if errorlevel 2 goto OPTIMIZACION
call :LOG "Limpiar temporales del usuario"
del /F /S /Q "%TEMP%\*.*" >nul 2>&1
for /D %%D in ("%TEMP%\*") do rd /S /Q "%%~fD" >nul 2>&1
echo.
echo   Limpieza finalizada. Los elementos bloqueados se conservaron.
call :PAUSA
goto OPTIMIZACION

:OPT_4
call :LOG "Abrir configuracion de almacenamiento"
start "" ms-settings:storagesense
goto OPTIMIZACION

:OPT_5
goto MENU

:: ============================================================================
:: 4. WINGET
:: ============================================================================
:WINGET
where.exe winget.exe >nul 2>&1
if errorlevel 1 goto WINGET_NO_DISPONIBLE

cls
call :ENCABEZADO
echo   ADMINISTRACION DE PROGRAMAS
echo  ------------------------------------------------------------------------------
echo.
echo   [1] Listar programas instalados
echo   [2] Mostrar actualizaciones disponibles
echo   [3] Actualizar todos los programas
echo   [4] Desinstalar un programa por nombre o ID
echo   [5] Exportar inventario de programas al Escritorio
echo   [0] Volver al menu principal
echo.
echo  ------------------------------------------------------------------------------
choice /C 123450 /N /M "  Seleccione una opcion [0-5]: "
goto WINGET_%errorlevel%

:WINGET_1
call :LOG "Winget list"
winget.exe list
call :PAUSA
goto WINGET

:WINGET_2
call :LOG "Winget upgrade list"
winget.exe upgrade
call :PAUSA
goto WINGET

:WINGET_3
cls
call :ENCABEZADO
echo   ACTUALIZACION MASIVA CON WINGET
echo  ------------------------------------------------------------------------------
echo.
choice /C SN /N /M "  Confirma winget upgrade --all? [S/N]: "
if errorlevel 2 goto WINGET
call :LOG "Winget upgrade all"
winget.exe upgrade --all
call :PAUSA
goto WINGET

:WINGET_4
cls
call :ENCABEZADO
set "PNAME="
set /P "PNAME=  Ingrese el nombre o ID exacto del programa: "
if not defined PNAME goto WINGET
winget.exe list "!PNAME!"
echo.
choice /C SN /N /M "  Confirma la desinstalacion? [S/N]: "
if errorlevel 2 goto WINGET
call :LOG "Winget uninstall"
winget.exe uninstall --exact "!PNAME!"
call :PAUSA
goto WINGET

:WINGET_5
set "WINGETFILE=%USERPROFILE%\Desktop\WinGet_%COMPUTERNAME%.json"
call :LOG "Exportar inventario Winget"
winget.exe export --output "%WINGETFILE%" --include-versions
if errorlevel 1 goto WINGET_EXPORT_ERROR
echo.
echo   Inventario guardado en:
echo   %WINGETFILE%
call :PAUSA
goto WINGET

:WINGET_EXPORT_ERROR
echo.
echo   No fue posible exportar el inventario de WinGet.
call :PAUSA
goto WINGET

:WINGET_6
goto MENU

:WINGET_NO_DISPONIBLE
cls
call :ENCABEZADO
echo   WINGET NO ESTA DISPONIBLE
echo  ------------------------------------------------------------------------------
echo.
echo   Verifique que App Installer este instalado y actualizado.
echo.
call :PAUSA
goto MENU

:: ============================================================================
:: 5. RED
:: ============================================================================
:RED
cls
call :ENCABEZADO
echo   DIAGNOSTICO Y REPARACION DE RED
echo  ------------------------------------------------------------------------------
echo.
echo   [1] Ver la configuracion completa de red
echo   [2] Ver conexiones activas y procesos asociados
echo   [3] Rastrear la ruta hacia un destino
echo   [4] Consultar la resolucion de nombres
echo   [5] Probar la conectividad de un puerto
echo   [6] Abrir los adaptadores de red
echo   [7] Vaciar la cache de nombres
echo   [8] Restablecer el catalogo de comunicaciones
echo   [9] Restablecer la configuracion de red
echo   [0] Volver al menu principal
echo.
echo  ------------------------------------------------------------------------------
choice /C 1234567890 /N /M "  Seleccione una opcion [0-9]: "
goto RED_%errorlevel%

:RED_1
call :LOG "IPConfig all"
ipconfig.exe /all
call :PAUSA
goto RED

:RED_2
call :LOG "Netstat ano"
netstat.exe -ano
call :PAUSA
goto RED

:RED_3
set "HOST="
set /P "HOST=  Ingrese un host o una direccion IP: "
if not defined HOST goto RED
call :LOG "Ejecutar tracert"
tracert.exe "!HOST!"
call :PAUSA
goto RED

:RED_4
set "HOST="
set /P "HOST=  Ingrese el dominio que desea consultar: "
if not defined HOST goto RED
call :LOG "Ejecutar nslookup"
nslookup.exe "!HOST!"
call :PAUSA
goto RED

:RED_5
set "HOST="
set "PORT="
set /P "HOST=  Ingrese el host o IP: "
if not defined HOST goto RED
set /P "PORT=  Ingrese el puerto TCP: "
if not defined PORT goto RED
call :LOG "Ejecutar Test-NetConnection"
powershell.exe -NoProfile -Command "Test-NetConnection -ComputerName $env:HOST -Port ([int]$env:PORT)"
call :PAUSA
goto RED

:RED_6
call :LOG "Abrir adaptadores de red"
start "" ncpa.cpl
goto RED

:RED_7
call :LOG "Vaciar cache DNS"
ipconfig.exe /flushdns
call :PAUSA
goto RED

:RED_8
cls
call :ENCABEZADO
echo   RESTABLECER WINSOCK
echo  ------------------------------------------------------------------------------
echo.
choice /C SN /N /M "  Confirma netsh winsock reset? [S/N]: "
if errorlevel 2 goto RED
call :LOG "Restablecer Winsock"
netsh.exe winsock reset
call :PAUSA
goto RED

:RED_9
cls
call :ENCABEZADO
echo   RESTABLECER PILA TCP/IP
echo  ------------------------------------------------------------------------------
echo.
choice /C SN /N /M "  Confirma netsh int ip reset? [S/N]: "
if errorlevel 2 goto RED
call :LOG "Restablecer TCP IP"
netsh.exe int ip reset
call :PAUSA
goto RED

:RED_10
goto MENU

:: ============================================================================
:: 6. CONSOLAS ADMINISTRATIVAS
:: ============================================================================
:ADMIN
cls
call :ENCABEZADO
echo   CONSOLAS ADMINISTRATIVAS DE WINDOWS
echo  ------------------------------------------------------------------------------
echo.
echo   [1] Panel de control             [8] Administrador de dispositivos
echo   [2] Configuracion del sistema     [9] Monitor de rendimiento
echo   [3] Administrador de tareas       [A] Visor de eventos
echo   [4] Administrador de discos       [B] Diagnostico de DirectX
echo   [5] Directivas de grupo           [C] Cuentas de usuario
echo   [6] Editor del registro           [D] Propiedades del sistema
echo   [7] Servicios                     [E] Administracion de equipos
echo   [0] Volver al menu principal
echo.
echo  ------------------------------------------------------------------------------
choice /C 123456789ABCDE0 /N /M "  Seleccione una opcion [1-9, A-E o 0]: "
goto ADMIN_%errorlevel%

:ADMIN_1
start "" control.exe
goto ADMIN
:ADMIN_2
start "" msconfig.exe
goto ADMIN
:ADMIN_3
start "" taskmgr.exe
goto ADMIN
:ADMIN_4
start "" diskmgmt.msc
goto ADMIN
:ADMIN_5
start "" gpedit.msc
goto ADMIN
:ADMIN_6
start "" regedit.exe
goto ADMIN
:ADMIN_7
start "" services.msc
goto ADMIN
:ADMIN_8
start "" devmgmt.msc
goto ADMIN
:ADMIN_9
start "" perfmon.exe
goto ADMIN
:ADMIN_10
start "" eventvwr.msc
goto ADMIN
:ADMIN_11
start "" dxdiag.exe
goto ADMIN
:ADMIN_12
start "" netplwiz.exe
goto ADMIN
:ADMIN_13
start "" sysdm.cpl
goto ADMIN
:ADMIN_14
start "" compmgmt.msc
goto ADMIN
:ADMIN_15
goto MENU

:: ============================================================================
:: 7. INFORME TECNICO
:: ============================================================================
:INFORME
cls
call :ENCABEZADO
echo   GENERAR INFORME TECNICO
echo  ------------------------------------------------------------------------------
echo.
echo   Se guardara informacion del sistema, red, controladores, servicios y eventos.
echo   El archivo puede contener nombres de usuario, IP y datos del equipo.
echo.
choice /C SN /N /M "  Confirma la generacion del informe? [S/N]: "
if errorlevel 2 goto MENU

set "REPORT=%USERPROFILE%\Desktop\Diagnostico_%COMPUTERNAME%.txt"
call :LOG "Generar informe tecnico"

>"%REPORT%" echo ALTAMIRATEC - INFORME TECNICO WINDOWS 11
>>"%REPORT%" echo Equipo: %COMPUTERNAME%
>>"%REPORT%" echo Usuario: %USERNAME%
>>"%REPORT%" echo Fecha: %DATE% %TIME%
>>"%REPORT%" echo ============================================================================
>>"%REPORT%" echo.
>>"%REPORT%" echo [SYSTEMINFO]
systeminfo.exe >>"%REPORT%" 2>&1
>>"%REPORT%" echo.
>>"%REPORT%" echo [IPCONFIG ALL]
ipconfig.exe /all >>"%REPORT%" 2>&1
>>"%REPORT%" echo.
>>"%REPORT%" echo [CONTROLADORES]
driverquery.exe /FO TABLE >>"%REPORT%" 2>&1
>>"%REPORT%" echo.
>>"%REPORT%" echo [SERVICIOS]
sc.exe query type= service state= all >>"%REPORT%" 2>&1
>>"%REPORT%" echo.
>>"%REPORT%" echo [EVENTOS CRITICOS Y ERRORES DEL SISTEMA]
wevtutil.exe qe System /q:"*[System[(Level=1 or Level=2)]]" /c:30 /rd:true /f:text >>"%REPORT%" 2>&1

echo.
echo   Informe generado correctamente:
echo   %REPORT%
call :PAUSA
goto MENU

:: ============================================================================
:: SUBRUTINAS
:: ============================================================================
:ENCABEZADO
echo.
echo  ================================================================================
echo   ALTAMIRATEC - HERRAMIENTAS DE SOPORTE PARA WINDOWS 11 - VERSION 1.0.0
echo  ================================================================================
echo   Equipo: %COMPUTERNAME%    Usuario: %USERNAME%
echo  ================================================================================
exit /b

:PAUSA
echo.
echo   Presione una tecla para continuar...
pause >nul
exit /b

:LOG
>>"%LOGFILE%" echo [%DATE% %TIME%] %~1
exit /b

:SALIR
call :LOG "Cierre de la herramienta"
cls
echo.
echo  ============================================================================
echo   ALTAMIRATEC - HERRAMIENTA FINALIZADA
echo  ============================================================================
echo.
endlocal
exit /b 0
