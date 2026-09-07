---
name: Cambio Script
about: Plantilla para reportar cambios en el script
title: ''
labels: documentation
assignees: ealtamiratec
type: Feature

---

# Descripción

Explique el problema resuelto y el comportamiento nuevo o corregido.

## Tipo de cambio

- [ ] Corrección de error
- [ ] Nueva función
- [ ] Mejora de seguridad
- [ ] Refactorización sin cambio funcional
- [ ] Documentación

## Impacto operativo

Describa si el cambio modifica archivos, componentes de Windows, aplicaciones, red, Registro, arranque o reinicio. Incluya el procedimiento de reversión cuando corresponda.

## Pruebas realizadas

| Dato | Resultado |
|---|---|
| Edición y compilación de Windows 11 |  |
| Entorno de laboratorio o máquina virtual |  |
| Inicio y elevación UAC |  |
| Navegación y cancelación |  |
| Operación afectada |  |
| Reversión comprobada |  |

## Lista de control

- [ ] Probé el cambio en Windows 11 fuera de un equipo de producción.
- [ ] Las operaciones destructivas requieren confirmación clara.
- [ ] Validé rutas, entradas y códigos de salida relevantes.
- [ ] No incluí informes, registros, credenciales ni datos personales.
- [ ] Conservé CRLF y compatibilidad de `Soporte-IT.bat`.
- [ ] Actualicé README, documentación de seguridad y CHANGELOG cuando corresponde.
