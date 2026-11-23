# Presentación — Bridge & Flyweight

Materiales de la exposición de los patrones estructurales **Bridge** y
**Flyweight**, con introducción y conclusiones.

## Contenido

| Archivo | Descripción |
|---|---|
| `Bridge-y-Flyweight-Patrones-Estructurales.pptx` | Presentación editable (14 slides, 16:9) |
| `Bridge-y-Flyweight-Patrones-Estructurales.pdf` | Respaldo para proyectar sin PowerPoint |
| `GUION.md` | Guion hablado, tiempos, demo y preguntas frecuentes |
| `preview/*.png` | Vista previa de cada slide |
| `generate-slides.ps1` | Script que regenera el PPTX y los PNG |

## Las 14 slides

1. Portada
2. Agenda
3. ¿Qué son los patrones de diseño?
4. ¿Qué son los patrones estructurales?
5. ¿Para qué sirven?
6. Bridge — el problema (explosión de clases)
7. Bridge — solución + UML
8. Bridge — código y cuándo usarlo
9. Flyweight — el problema (200.000 árboles)
10. Flyweight — solución + UML
11. Flyweight — código y cuándo usarlo
12. Conclusiones — cuadro comparativo de los 7 patrones
13. Conclusiones — guía rápida de elección
14. Cierre

Cada slide incluye **notas del expositor** dentro del PPTX (panel de notas).

## Regenerar la presentación

Requiere **Windows + Microsoft PowerPoint** y PowerShell.

```powershell
cd slides
powershell -ExecutionPolicy Bypass -File .\generate-slides.ps1
```

El script crea el `.pptx`, el `.pdf` y vuelve a exportar las imágenes de
`preview/`. Los diagramas UML son formas nativas de PowerPoint, así que se
pueden editar directamente.

## Personalizar

- **Integrantes:** slide 1, texto `Integrantes: ______`.
- **Colores:** variables `$CL_*` al inicio de `generate-slides.ps1`.
- **Tipografías:** Segoe UI (texto) y Consolas (código y UML).
- **Contenido:** edita las secciones `# ==== 01 PORTADA`, etc. del script y
  vuelve a ejecutarlo. También puedes editar el PPTX directamente.

## Notas

- La presentación está en español y usa 16:9 (960 × 540 pt).
- El código de las slides es una versión resumida del ejemplo real del repo;
  el ejemplo completo está en [`../flyweight/`](../flyweight/) y
  [`../bridge/`](../bridge/).
- Si no tienes PowerPoint, el PDF sirve para exponer, pero no se puede editar.
