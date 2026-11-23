# Patron Flyweight — Bosque con 200.000 arboles

Ejemplo completo en Java del patron estructural **Flyweight**. Se plantan
**200.000 arboles** de solo **4 especies**; los datos que se repiten (especie,
color y textura) se guardan una sola vez y se comparten entre todos los arboles.

## El problema

En un bosque cada arbol necesita especie, color, textura y posicion. Si cada uno
guarda su propia copia de la textura de 2 KB:

```
200.000 arboles × 2 KB = ~400 MB solo en texturas
```

La mayoria de esos datos son **identicos** entre arboles de la misma especie.
Guardarlos repetidos desperdicia memoria y hace que crear el bosque sea lento.

## La solucion: separar estado intrinseco y extrinseco

| Estado | Que es | Donde vive | Ejemplo |
|---|---|---|---|
| **Intrinseco** | Se repite y no cambia | En el flyweight (`TreeType`) | especie, color, textura |
| **Extrinseco** | Es unico de cada objeto | En el contexto (`Tree`) | posicion `x`, `y` |

El **FlyweightFactory** mantiene un cache: si el tipo `Roble|verde` ya existe,
devuelve la misma instancia; si no, la crea y la guarda. Los arboles solo guardan
`x`, `y` y una referencia al tipo compartido.

```
                         ┌──────────────────────┐
   Forest ──1..*──► Tree │ - x: int             │
                         │ - y: int             │
                         │ - type: TreeType ────┼──┐
                         └──────────────────────┘  │
                                                   │  *
                         ┌──────────────────────┐  │
                         │ TreeType (flyweight) │◄─┘
                         │ - species: String    │
                         │ - color: String      │
                         │ - texture: byte[]    │
                         └──────────────────────┘
                                   ▲
                                   │ crea / reutiliza
                         ┌──────────────────────┐
                         │ TreeFactory          │
                         │ - cache: Map         │
                         └──────────────────────┘
```

## Estructura del proyecto

```
flyweight/
├── pom.xml
├── README.md
└── src
    ├── main/java/com/patrones/estructurales/flyweight
    │   ├── TreeType.java      # Flyweight: estado intrinseco inmutable
    │   ├── Tree.java          # Contexto: posicion + referencia al flyweight
    │   ├── TreeFactory.java   # Fabrica con cache
    │   ├── Forest.java        # Cliente: planta y dibuja arboles
    │   └── Main.java          # Demo con 200.000 arboles
    └── test/java/com/patrones/estructurales/flyweight
        └── FlyweightTest.java # 5 pruebas unitarias
```

## Como funciona el codigo

### 1. Flyweight: `TreeType`

Guarda solo lo que comparten los arboles de la misma especie. Es `final`, sus
campos son `final` y la textura se copia en el constructor para que nadie pueda
modificarla desde fuera.

```java
public final class TreeType {
    private final String species;
    private final String color;
    private final byte[] texture;

    TreeType(String species, String color, byte[] texture) {
        this.species = species;
        this.color = color;
        this.texture = texture.clone();
    }

    public String render(int x, int y) {   // recibe el estado extrinseco
        return String.format("%s %s en (%d, %d) [textura %d B]",
                species, color, x, y, texture.length);
    }
}
```

El constructor es **package-private**: solo `TreeFactory` puede crear flyweights.
Asi se garantiza que siempre pasen por el cache.

### 2. Contexto: `Tree`

Hay 200.000 instancias de esta clase, por eso solo tiene lo minimo:

```java
public final class Tree {
    private final int x;
    private final int y;
    private final TreeType type;   // referencia compartida

    public String render() {
        return type.render(x, y);   // combina extrinseco + intrinseco
    }
}
```

### 3. Fabrica: `TreeFactory`

```java
public TreeType getTreeType(String species, String color, Supplier<byte[]> textureLoader) {
    String key = species + "|" + color;

    TreeType existing = cache.get(key);
    if (existing != null) {
        cacheHits++;
        return existing;                   // reutiliza el flyweight
    }

    TreeType created = new TreeType(species, color, textureLoader.get());
    cache.put(key, created);               // lo crea solo la primera vez
    return created;
}
```

La textura se carga con un `Supplier`, de modo que el archivo o la imagen solo
se lee cuando el tipo aparece por primera vez. La clave del cache debe incluir
**todo** el estado intrinseco.

### 4. Cliente: `Forest` y `Main`

`Forest.plant(...)` pide el tipo a la fabrica y crea un `Tree` liviano. `Main`
planta 200.000 arboles de 4 especies y compara la memoria estimada.

## Como ejecutarlo

Requiere Java 17+ y Maven 3.9+.

```bash
cd flyweight
mvn test
mvn compile exec:java
```

Salida esperada (los decimales pueden variar segun la configuracion regional):

```
=== Bosque con Flyweight ===
Arboles plantados : 200000
Tipos creados     : 4 (una vez por especie)
Reutilizaciones   : 199996

=== Primeros 5 arboles (estado extrinseco + intrinseco) ===
  Sauce claro en (2763, 1248) [textura 2048 B]
  Roble verde en (9970, 7525) [textura 2048 B]
  Pino oscuro en (6918, 5519) [textura 2048 B]
  Roble verde en (7182, 7502) [textura 2048 B]
  Pino oscuro en (2292, 4476) [textura 2048 B]

=== Memoria estimada de texturas ===
Sin Flyweight (200.000 texturas) :   402,83 MB
Con Flyweight (solo 4 texturas)  :     7,64 MB
Ahorro                           :    98,10%
```

> La estimacion usa un costo fijo por objeto (64 B sin Flyweight, 40 B con
> Flyweight) mas el tamano de la textura. Es una aproximacion didactica; lo
> importante es la diferencia de orden de magnitud: **4 texturas en vez de
> 200.000**.

## Pruebas unitarias

`FlyweightTest` verifica las propiedades del patron:

1. La fabrica devuelve **la misma instancia** para la misma clave.
2. Claves distintas producen flyweights distintos.
3. La textura se carga **una sola vez** aunque se pida 1.000 veces.
4. 5.000 arboles comparten un solo `TreeType`.
5. Cada arbol conserva su propia posicion (estado extrinseco).

```bash
mvn test
# Tests run: 5, Failures: 0, Errors: 0, Skipped: 0
```

## Cuando usarlo

- Cuando una aplicacion crea **muchisimos objetos** y gran parte de su estado se repite.
- Cuando el costo de memoria domina el rendimiento y los objetos se pueden agrupar
  por una clave comun.
- Cuando puedes separar claramente estado **intrinseco** (compartido) y
  **extrinseco** (aportado por el cliente).
- Cuando el numero de combinaciones distintas es pequeno comparado con el numero
  de instancias.

Ejemplos reales:

- **`String` pool** de Java y `Integer.valueOf()` (cache de -128 a 127).
- **Glyphs** en editores de texto: cada caracter comparte la forma de la fuente y
  el documento guarda posiciones.
- **Particulas** en videojuegos (balas, humo, chispas) con el mismo sprite.
- **Iconos** repetidos en mapas o tableros.
- **Conexiones o configuraciones** repetidas en servidores.

## Ventajas y desventajas

**Ventajas**

- Reduce drasticamente el uso de memoria.
- Disminuye el costo de crear y recolectar miles de objetos.
- Centraliza el estado compartido en un solo lugar.

**Desventajas**

- Agrega una fabrica y una indireccion en cada acceso.
- Hay que identificar correctamente que estado es intrinseco y cual extrinseco.
- El estado extrinseco se recalcula o se pasa en cada operacion.
- Los flyweights deben ser **inmutables**; si se comparten y se modifican, todos
  los contextos ven el cambio.
- La fabrica debe ser segura si se usa desde varios hilos.

## Relacion con otros patrones

- **Flyweight** suele combinarse con **Composite** (nodos hoja compartidos) y con
  **Factory** (la cache se implementa como una fabrica).
- **Singleton** garantiza una sola instancia global; **Flyweight** garantiza una
  sola instancia **por clave**.
- **State** y **Strategy** pueden usar flyweights cuando sus objetos son inmutables
  y se repiten.
