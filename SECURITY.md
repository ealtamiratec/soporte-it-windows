# Política de seguridad

## Versiones compatibles

Hasta que exista una nueva publicación, la versión **3.0.x** es la única rama prevista para recibir correcciones de seguridad.

| Versión | Compatibilidad |
|---|---|
| 3.0.x | Compatible |
| Menores que 3.0 | No definida |

## Reporte de vulnerabilidades

No publique inicialmente una incidencia abierta si el problema puede provocar ejecución de comandos no previstos, pérdida de datos, desinstalación incorrecta, exposición de información, elevación insegura, interrupción de red o reinicio inesperado.

Utilice **Private vulnerability reporting** o un borrador privado de aviso de seguridad en GitHub cuando el repositorio lo tenga habilitado. Si se establece un correo específico para seguridad, añádalo aquí antes de publicar; evite utilizar un número telefónico personal como canal de reporte.

El informe debe describir la versión, edición y compilación de Windows, la opción de menú afectada, los pasos de reproducción, el resultado observado, el impacto potencial y cualquier mitigación conocida. No adjunte informes técnicos sin anonimizar, credenciales, direcciones IP públicas, nombres de clientes ni registros que permitan identificar un equipo.

## Alcance prioritario

| Área | Ejemplos de problemas relevantes |
|---|---|
| Elevación | Uso inseguro de rutas, relanzamiento incorrecto o ejecución distinta del BAT esperado. |
| Entrada del usuario | Inyección de comandos o validación insuficiente de host, puerto, nombre o ID de paquete. |
| Archivos | Escritura o eliminación fuera de las rutas mostradas al operador. |
| Privacidad | Registro o exposición de información no anunciada. |
| Integridad | Mensajes de éxito cuando una reparación o exportación falló. |
| Disponibilidad | Reinicios, restablecimientos o bloqueos sin confirmación efectiva. |

## Divulgación responsable

Una vez confirmado el problema, se debe preparar una corrección, documentar el impacto, actualizar `CHANGELOG.md` y publicar una nueva versión. La divulgación pública debe esperar hasta que exista una mitigación razonable y los usuarios puedan actualizar de forma segura.

> **Importante:** este proyecto ejecuta tareas administrativas. Un fallo funcional puede convertirse en un problema de seguridad o disponibilidad aunque no exista un atacante externo.
