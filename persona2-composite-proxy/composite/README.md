# Patrón Composite — Sistema de archivos

**Autor:** Santiago Alonso · Grupo 7 — Patrones estructurales

## ¿Qué es?
Composite es un patrón estructural que organiza objetos en forma de **árbol** y permite
trabajar con todo el árbol como si fuera **un solo objeto**. El cliente no necesita saber
si usa un elemento simple o uno que contiene otros.

## Problema
Una carpeta puede tener archivos y otras carpetas, sin límite de niveles. Para saber
cuánto pesa una carpeta habría que recorrer todo con bucles anidados y preguntar a cada
paso "¿esto es archivo o carpeta?". Ese código se complica y se rompe si aparece un nivel más.

## Solución
Una interfaz común, `ElementoSistema`, con el método `getTamano()`:
- **Archivo** devuelve su propio tamaño.
- **Carpeta** le pide el tamaño a cada hijo y suma. Si un hijo es otra carpeta, esta
  hace lo mismo (**recursión**), hasta llegar a los archivos.

## Roles del patrón

| Rol        | Clase             | Qué hace                                  |
|------------|-------------------|-------------------------------------------|
| Componente | `ElementoSistema` | Interfaz común para hojas y compuestos    |
| Hoja       | `Archivo`         | Elemento simple; hace el trabajo real     |
| Compuesto  | `Carpeta`         | Contiene hijos y les delega el trabajo    |
| Cliente    | `Main`            | Usa todo a través de `ElementoSistema`    |

```
          «interfaz»
        ElementoSistema
        + getTamano()
        + mostrar()
          ▲         ▲
          |         |
      Archivo     Carpeta ◇── hijos: List<ElementoSistema>
                  + agregar()
                  + eliminar()
```

## Cómo ejecutarlo
- **VS Code:** abre `Main.java` y dale **Run**.
- **Maven:** desde esta carpeta:
  ```bash
  mvn compile exec:java   # ejecuta el Main
  mvn test                # corre las 6 pruebas
  ```

## Salida esperada
```
+ mi-proyecto/ (1474 KB)
    - README.md (4 KB)
    + src/ (20 KB)
        - Main.java (12 KB)
        + utils/ (8 KB)
            - Helper.java (8 KB)
    + imagenes/ (1450 KB)
        - logo.png (250 KB)
        - fondo.jpg (1200 KB)
...
=== Se borra fondo.jpg ===
mi-proyecto -> 274 KB
```

## Qué observar
- `imprimirTamano()` recibe un `ElementoSistema`: funciona igual con un archivo que con
  una carpeta llena de subcarpetas.
- Para agregar un tipo nuevo (por ejemplo, `AccesoDirecto`) basta con implementar la
  interfaz, sin tocar lo existente (principio abierto/cerrado).
- Al borrar un archivo, el tamaño de todas las carpetas que lo contienen se actualiza solo.

## Ventajas y desventajas
- ✓ Polimorfismo y recursión simplifican el trabajo con árboles.
- ✓ Nuevos tipos de elementos sin modificar el código existente.
- ✗ Si las clases son muy distintas, la interfaz común queda demasiado general.

Referencia: https://refactoring.guru/es/design-patterns/composite