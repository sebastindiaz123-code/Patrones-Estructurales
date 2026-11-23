# Patrones Estructurales (GoF)

Repositorio de la exposición de **patrones de diseño estructurales** en Java.

Los patrones estructurales explican **cómo componer clases y objetos** para formar
estructuras más grandes y flexibles, manteniendo bajo el acoplamiento.

## Contenido

| Carpeta | Patrón | Estado |
|---|---|---|
| [`bridge/`](bridge/README.md) | Bridge | ✅ Ejemplo + pruebas + README |
| [`flyweight/`](flyweight/README.md) | Flyweight | ✅ Bosque con 200.000 árboles + pruebas + README |
| [`slides/`](slides/) | Presentación | ✅ PPTX + guion de exposición |

Los demás patrones estructurales (Adapter, Composite, Decorator, Facade y Proxy)
se agregan en sus propias carpetas.

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
Patrones-Estructurales/
├── bridge/          # Patrón Bridge: formas + renderizadores
├── flyweight/       # Patrón Flyweight: bosque con flyweights compartidos
├── slides/          # Presentación y guion
└── README.md
```
