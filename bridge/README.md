# Patron Bridge — Formas y renderizadores

Ejemplo en Java del patron estructural **Bridge**. Las figuras (`Circle`, `Square`)
se dibujan con distintas tecnologias (`VectorRenderer`, `RasterRenderer`) sin crear
una subclase por cada combinacion.

## El problema

Si se usa solo herencia, cada figura necesita una subclase por cada tecnologia:

```
Shape
├── CircleVector
├── CircleRaster
├── SquareVector
└── SquareRaster
```

Con 3 figuras y 4 renderizadores serian **12 clases**, y agregar una figura o un
renderizador obliga a crear varias clases nuevas. El crecimiento es multiplicativo.

## La solucion

Bridge separa las dos dimensiones que cambian por su cuenta:

- **Abstraction** (`Shape`): el concepto de dominio (figura). Contiene la referencia
  al implementador.
- **RefinedAbstraction** (`Circle`, `Square`): variantes de la abstraccion.
- **Implementor** (`Renderer`): la interfaz de la tecnologia de dibujo.
- **ConcreteImplementor** (`VectorRenderer`, `RasterRenderer`): implementaciones.

```
        Shape ────────────► Renderer
     (abstraccion)      (implementor)
      /       \            /        \
  Circle    Square   Vector      Raster
```

La flecha con rombo (agregacion) es el **puente**: `Shape` delega el dibujo en un
`Renderer` que recibe por constructor.

Ahora hay `3 + 3 = 6` clases en lugar de `3 × 3 = 9`, y cada dimension crece de
forma lineal: una figura nueva es 1 clase; un renderizador nuevo es 1 clase.

## Estructura del proyecto

```
bridge/
├── pom.xml
└── src
    ├── main/java/com/patrones/estructurales/bridge
    │   ├── Renderer.java          # Implementor
    │   ├── VectorRenderer.java    # ConcreteImplementor
    │   ├── RasterRenderer.java    # ConcreteImplementor
    │   ├── Shape.java             # Abstraction (tiene el puente)
    │   ├── Circle.java            # RefinedAbstraction
    │   ├── Square.java            # RefinedAbstraction
    │   └── Main.java              # Demo
    └── test/java/com/patrones/estructurales/bridge
        └── BridgeTest.java        # 4 pruebas unitarias
```

## Codigo clave

```java
public interface Renderer {          // Implementor
    String circle(double radius);
    String square(double side);
}

public abstract class Shape {        // Abstraction
    protected final Renderer renderer;

    protected Shape(Renderer renderer) {
        this.renderer = renderer;
    }

    public abstract String draw();
    public abstract double area();
}

public class Circle extends Shape {  // RefinedAbstraction
    private final double radius;

    public Circle(double radius, Renderer renderer) {
        super(renderer);
        this.radius = radius;
    }

    @Override
    public String draw() {
        return renderer.circle(radius);   // delega en el puente
    }

    @Override
    public double area() {
        return Math.PI * radius * radius;
    }
}
```

Uso:

```java
Shape circle = new Circle(5, new VectorRenderer());
Shape same   = new Circle(5, new RasterRenderer());

System.out.println(circle.draw()); // Circulo vectorial (r=5,0)
System.out.println(same.draw());   // Circulo rasterizado (r=5,0 px)
```

## Como ejecutarlo

Requiere Java 17+ y Maven 3.9+.

```bash
cd bridge
mvn test          # ejecuta las pruebas
mvn compile exec:java
```

Salida del demo:

```
=== Mismas figuras, dos renderizadores ===
vectorial  | Circulo vectorial (r=5,0)          | area =   78,54
vectorial  | Cuadrado vectorial (lado=4,0)      | area =   16,00
raster     | Circulo rasterizado (r=5,0 px)     | area =   78,54
raster     | Cuadrado rasterizado (lado=4,0 px) | area =   16,00

=== Un renderizador nuevo no toca las figuras ===
ascii      | ( ) circulo ascii r=5,0            | area =   78,54
ascii      | [ ] cuadrado ascii lado=4,0        | area =   16,00
```

El demo agrega un tercer renderizador (`AsciiRenderer`) dentro de `Main` para
demostrar que `Shape`, `Circle` y `Square` no se modifican.

## Cuando usarlo

- Cuando una clase tiene **dos (o mas) dimensiones que varian de forma independiente**
  y la herencia produce una explosion de subclases.
- Cuando quieres cambiar la implementacion en **tiempo de ejecucion**
  (por ejemplo, alternar render vectorial / raster).
- Cuando quieres que la abstraccion y la implementacion puedan **evolucionar por separado**.
- Cuando necesitas ocultar la implementacion concreta al cliente.

Ejemplos reales: JDBC (`Connection` / `Driver`), las APIs de dibujo de AWT,
reproductores con distintos codecs, notificaciones (tipo de mensaje x canal),
controles remotos y dispositivos.

## Ventajas y desventajas

**Ventajas**

- Elimina el crecimiento multiplicativo de subclases.
- Bajo acoplamiento entre abstraccion e implementacion.
- Principio abierto/cerrado: nuevas figuras y nuevos renderizadores sin tocar el otro lado.
- Permite intercambiar la implementacion en tiempo de ejecucion.

**Desventajas**

- Aumenta el numero de clases y la indireccion.
- Para jerarquias simples puede ser sobreingenieria.
- El cliente debe entender la diferencia entre abstraccion e implementador para
  elegir la combinacion correcta.

## Relacion con otros patrones

- **Adapter** hace que interfaces incompatibles colaboren; **Bridge** separa dos
  jerarquias desde el diseno.
- **Strategy** encapsula un algoritmo intercambiable; **Bridge** estructura dos
  jerarquias completas (abstraccion + implementacion).
- **Abstract Factory** puede crear las implementaciones concretas que usa el Bridge.
