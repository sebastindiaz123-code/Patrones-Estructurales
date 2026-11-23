# Persona 3 — Bridge y Flyweight

Aporte de la Persona 3 a la exposición de **patrones de diseño estructurales**
en Java: introducción, los patrones **Bridge** y **Flyweight**, y conclusiones.

Los patrones estructurales explican **cómo componer clases y objetos** para formar
estructuras más grandes y flexibles, manteniendo bajo el acoplamiento.

## Contenido

| Carpeta | Patrón | Estado |
|---|---|---|
| [`bridge/`](bridge/README.md) | Bridge | ✅ Ejemplo + pruebas + README |
| [`flyweight/`](flyweight/README.md) | Flyweight | ✅ Bosque con 200.000 árboles + pruebas + README |
| [`slides/`](slides/) | Presentación | ✅ PPTX + PDF + guion de exposición |

Los demás patrones estructurales (Adapter, Composite, Decorator, Facade y Proxy)
se agregan en las carpetas de los demás integrantes.

## Requisitos

- Java 17 o superior
- Maven 3.9 o superior

Cada ejemplo es un proyecto Maven independiente:

```bash
cd bridge     && mvn test
cd flyweight  && mvn test
```

## Estructura

```
persona3-flyweight/
├── bridge/          # Patrón Bridge: formas + renderizadores
├── flyweight/       # Patrón Flyweight: bosque con flyweights compartidos
├── slides/          # Presentación, PDF, guion y previews
└── README.md
```
