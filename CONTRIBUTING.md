# Guía de contribución

Gracias por contribuir a **Soporte IT para Windows 11**. Debido a que el proyecto ejecuta comandos administrativos, cada cambio debe priorizar la seguridad, la trazabilidad y la posibilidad de recuperación.

## Alcance de las contribuciones

Se aceptan correcciones de errores, mejoras de compatibilidad, mensajes más claros, controles de confirmación, validación de códigos de salida, documentación y nuevas funciones de diagnóstico o soporte. Las propuestas que modifiquen el sistema deben explicar el beneficio, los riesgos, los privilegios necesarios y el método de reversión.

| Tipo de cambio | Información obligatoria |
|---|---|
| Corrección | Problema reproducible, causa, cambio aplicado y evidencia de prueba. |
| Nueva función | Caso de uso, versiones de Windows probadas, comandos ejecutados, impacto y reversión. |
| Operación destructiva | Confirmación previa, advertencia visible, validación de parámetros y plan de recuperación. |
| Documentación | Sección afectada, motivo y enlaces a documentación oficial cuando corresponda. |
| Seguridad | Reporte privado según `SECURITY.md`; no abrir inicialmente una incidencia pública. |

## Flujo recomendado

Cree una rama con un nombre descriptivo, realice cambios pequeños y revise el archivo completo antes de confirmar. Mantenga el BAT en ASCII mientras esa sea la convención del proyecto y conserve terminadores CRLF. No agregue informes técnicos, inventarios, registros, capturas con datos personales ni archivos obtenidos de equipos de clientes.

```bash
git switch -c fix/descripcion-breve
git status
git diff --check
git add .
git commit -m "fix: describir el cambio"
```

## Pruebas mínimas

Las pruebas deben ejecutarse en Windows 11, preferentemente en una máquina virtual con instantánea. Verifique el inicio sin privilegios, la elevación UAC, navegación de menús, cancelación de confirmaciones, códigos de salida y retorno correcto al módulo correspondiente.

Para funciones que cambien el sistema, documente la edición y compilación de Windows, si el equipo tenía WinGet, el comando exacto, el resultado esperado, el resultado observado y el procedimiento usado para restaurar el entorno. No pruebe por primera vez un cambio destructivo en un equipo de producción.

## Criterios de aceptación

| Criterio | Requisito |
|---|---|
| Compatibilidad | No rompe el inicio, la elevación ni la navegación del menú. |
| Seguridad | Las acciones destructivas tienen confirmación y parámetros controlados. |
| Privacidad | No introduce telemetría, credenciales ni datos personales innecesarios. |
| Errores | Valida `errorlevel` cuando el resultado determina el mensaje mostrado. |
| Registros | No registra secretos y diferencia entre inicio, éxito y fallo cuando sea posible. |
| Documentación | Actualiza README, análisis funcional, seguridad y CHANGELOG según corresponda. |

## Estilo del Batch

Utilice nombres de etiquetas y variables descriptivos, comillas en rutas y variables que puedan contener espacios, y `set "VARIABLE=valor"` para reducir errores de espacios finales. Mantenga la expansión retardada solo cuando sea necesaria y valide cualquier entrada antes de convertirla o pasarla a otro intérprete.

Los comandos de PowerShell incrustados deben evitar concatenar datos no confiables dentro de código ejecutable. Siempre que sea posible, pase la información mediante variables de entorno o argumentos claramente delimitados.

## Mensajes de commit

Se recomienda usar prefijos como `feat`, `fix`, `docs`, `refactor`, `test`, `security` o `chore`. El asunto debe expresar el resultado del cambio y no solo el archivo modificado.
