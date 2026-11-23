# Persona 2 — Composite y Proxy

**Autor:** Santiago Alonso · Grupo 7 — Patrones estructurales

Esta carpeta contiene mi aporte al trabajo: dos ejemplos en Java (Maven) de patrones
estructurales, cada uno con su código, pruebas y explicación.

## Contenido

| Patrón | Carpeta | Ejemplo | Pruebas |
|---|---|---|---|
| **Composite** | [`composite/`](composite) | Sistema de archivos que calcula el tamaño total de carpetas anidadas | 6 |
| **Proxy** | [`proxy/`](proxy) | Proxy de caché para una API de clima lenta (6 → 3 llamadas) | 5 |

Cada carpeta tiene su propio README con el problema, la solución, el diagrama UML y qué
observar al ejecutarlo.

## Estructura
```
persona2-composite-proxy/
├── composite/   proyecto Maven del patrón Composite
├── proxy/       proyecto Maven del patrón Proxy
└── README.md
```

## Cómo ejecutar
Requisitos: Java 17 o superior (y Maven si se usa por consola).

- **VS Code:** abrir el `Main.java` del patrón y dar **Run**.
- **Maven:** entrar a la carpeta del patrón y ejecutar:
  ```bash
  mvn compile exec:java   # ejecuta el ejemplo
  mvn test                # corre las pruebas
  ```

## Referencias
- https://refactoring.guru/es/design-patterns/composite
- https://refactoring.guru/es/design-patterns/proxy