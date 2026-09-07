# Historial de cambios

Todos los cambios relevantes del proyecto se documentarán en este archivo. El formato sigue una estructura legible por versiones y separa funciones, cambios, correcciones y aspectos de seguridad.

## [Sin publicar]

No existen cambios funcionales pendientes registrados. Antes de una nueva versión, documente aquí las modificaciones, las pruebas realizadas y cualquier cambio en requisitos o riesgo operativo.

## [1.0.0] - 2026-09-06

### Incluido

Se incorpora la versión 1.0.0 de `Soporte-IT.bat`, una consola administrativa para Windows 11 con módulos de información del sistema, reparación mediante DISM/SFC/CHKDSK, optimización, limpieza de temporales, administración de programas con WinGet, diagnóstico y restablecimiento de red, acceso a consolas administrativas y generación de informes técnicos.

También se incorpora la documentación inicial para GitHub, con análisis funcional, evaluación de seguridad y privacidad, instrucciones de publicación, guía de contribución, política de seguridad, reglas de exclusión y normalización de finales de línea.

### Seguridad

La preparación identifica como operaciones de mayor impacto el reinicio forzado, CHKDSK con reparación, actualización o desinstalación mediante WinGet, limpieza de temporales y restablecimiento de Winsock/TCP-IP. También advierte que los informes generados pueden contener datos sensibles.
