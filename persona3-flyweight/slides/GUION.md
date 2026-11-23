# Guion de exposición — Bridge & Flyweight

**Duración objetivo:** 11–13 minutos + preguntas.
**Slides:** 14 (16:9).
**Archivos:** `Bridge-y-Flyweight-Patrones-Estructurales.pptx` (editable) y `.pdf` (respaldo).

| Bloque | Slides | Tiempo |
|---|---|---|
| Introducción | 1–5 | ≈ 3 min |
| Bridge | 6–8 | ≈ 3 min |
| Flyweight | 9–11 | ≈ 4 min |
| Conclusiones | 12–14 | ≈ 2 min |

> **Antes de exponer:** completa los nombres en la slide 1. Si el profe pide el
> repositorio, la URL ya está en la slide 14.

---

## Slide 1 — Portada

> «Buenos días. Somos [nombres] y hoy les vamos a hablar de dos patrones
> estructurales: **Bridge** y **Flyweight**. La idea que atraviesa toda la
> exposición es simple: cómo **desacoplar** dos cosas que cambian por separado y
> cómo **compartir** lo que se repite para no desperdiciar memoria. Al final
> dejamos un cuadro comparativo con los siete patrones estructurales y el código
> completo en GitHub.»

**Tip:** señala el mini diagrama de la derecha: «arriba, un puente entre
abstracción e implementación; abajo, muchos árboles apuntando a un solo modelo».

---

## Slide 2 — Agenda

> «Tenemos cuatro bloques: una introducción rápida, Bridge, Flyweight y
> conclusiones. En Flyweight hacemos una demo en vivo con 200.000 árboles.»

No te detengas mucho aquí: 20–30 segundos.

---

## Slide 3 — ¿Qué son los patrones de diseño?

> «Un patrón de diseño no es código ni una librería. Es una **plantilla de
> solución** que se adapta a un contexto: describe un problema, una solución y
> sus consecuencias. Los recopiló el grupo GoF en 1994: cuatro autores, 23
> patrones, tres familias.»

- **Creacionales (5):** cómo crear objetos.
- **Estructurales (7):** cómo componerlos. *Nuestra parte.*
- **De comportamiento (11):** cómo colaboran.

**Transición:** «Nosotros estamos en la familia del medio: los estructurales.»

---

## Slide 4 — ¿Qué son los patrones estructurales?

> «Se enfocan en cómo se componen clases y objetos para formar estructuras más
> grandes, sin aumentar el acoplamiento. Hay dos sabores: los de **clases**, que
> usan herencia e interfaces —Adapter y Bridge—, y los de **objetos**, que usan
> composición y delegación —Composite, Decorator, Facade, Flyweight y Proxy—.
> La regla moderna es preferir composición sobre herencia.»

Recorre los siete nombres sin explicarlos todos: «hoy profundizamos en estos dos»,
señalando Bridge y Flyweight.

---

## Slide 5 — ¿Para qué sirven?

> «Sirven para bajar el costo del cambio: desacoplan, simplifican, permiten
> reutilizar y a veces optimizan recursos. Pero ojo: un patrón mal aplicado
> también es deuda técnica. Primero identificamos el problema; después le ponemos
> el nombre.»

**Frase para recordar:** «los patrones son vocabulario, no recetas».

---

## Slide 6 — Bridge: el problema

> «Imaginemos figuras que se pueden dibujar de varias formas. Tenemos dos
> dimensiones: la figura —círculo, cuadrado, triángulo— y el renderizador
> —vectorial o raster—. Si resolvemos esto solo con herencia, necesitamos una
> clase por cada combinación: CirculoVector, CirculoRaster, CuadradoVector...
> Tres por dos son seis clases, y agregar una figura cuesta dos clases nuevas;
> agregar un renderizador cuesta tres. El crecimiento es **multiplicativo** y el
> método `draw()` se duplica en todas.»

Señala la fórmula y el recuadro rojo.

---

## Slide 7 — Bridge: la solución + UML

> «Bridge separa las dos dimensiones. `Shape` es la **abstracción** y guarda una
> referencia a `Renderer`, el **implementador**. `Circle` y `Square` heredan de
> `Shape`; `VectorRenderer` y `RasterRenderer` implementan `Renderer`. La línea
> con rombo significa “tiene un”: ese es el puente. La flecha punteada significa
> “implementa”. Lo clave: `Shape` no sabe dibujar, **delega** en el renderer.»

**Números:** «Pasamos de 3×3 = 9 combinaciones a 3+3 = 6 clases. Cada eje crece
de forma lineal: una figura nueva es una clase; un renderizador nuevo es una
clase.»

---

## Slide 8 — Bridge: código y cuándo usarlo

> «Este es el código mínimo. `Renderer` es la interfaz; `Shape` recibe el
> renderer por constructor y `Circle.draw()` delega en `renderer.circle(radius)`.
> Para agregar un renderizador 3D solo creamos una clase que implemente
> `Renderer`; no tocamos las figuras.»

**Cuándo usarlo:**
- dos dimensiones que varían por separado;
- cambiar la implementación en tiempo de ejecución;
- ocultar la implementación al cliente.

**Ejemplos reales:** JDBC (`Connection` es la abstracción, `Driver` la
implementación), AWT y sus *peers* nativos, notificaciones (tipo de mensaje ×
canal).

**Costo:** más clases e indirección. Si solo hay una dimensión, no vale la pena.

---

## Slide 9 — Flyweight: el problema

> «Ahora el otro extremo: tenemos 200.000 árboles, pero solo 4 especies. Cada
> árbol necesita posición, especie, color y textura. Si cada uno guarda su propia
> textura de 2 KB, son casi **400 MB** solo en texturas, y más del 98% de esa
> información es idéntica. El problema no es la cantidad de árboles: es que
> estamos repitiendo el mismo estado.»

---

## Slide 10 — Flyweight: la solución + UML

> «La solución es separar el estado en dos. Lo **intrínseco** —especie, color y
> textura— va en `TreeType`: es inmutable y se comparte. Lo **extrínseco** —la
> posición x, y— va en `Tree`, junto con una referencia al tipo. La
> `TreeFactory` mantiene un cache por especie y color: la primera vez crea el
> flyweight; las siguientes lo reutiliza.»

**Clave:** «200.000 árboles, 4 texturas». La posición se pasa en cada operación,
no se guarda en el flyweight.

---

## Slide 11 — Flyweight: código y cuándo usarlo

> «`TreeType` es `final`, sus campos son `final` y el constructor es
> *package-private*: solo la fábrica puede crearlo. La fábrica usa un `Map` con
> clave especie+color y `computeIfAbsent`: si existe lo devuelve, si no lo crea.
> `Tree` solo guarda x, y y la referencia.»

**Cuándo usarlo:** miles de objetos con estado repetido, estado compartido
inmutable y pocas combinaciones distintas.

**En Java ya existe:** el `String` pool y `Integer.valueOf()` (cache de −128 a
127). También se usa en *glyphs* de fuentes y sprites de videojuegos.

**Cuidado:** si el flyweight se modifica, todos los contextos cambian. La fábrica
debe ser segura entre hilos.

### Demo en vivo (1–2 min)

```bash
cd flyweight
mvn test
mvn compile exec:java
```

Puntos a resaltar de la salida:

- `Tipos creados: 4` aunque se plantaron 200.000 árboles.
- `Reutilizaciones: 199996`.
- `Sin Flyweight: 402,83 MB` vs. `Con Flyweight: 7,64 MB` → `98,10%` de ahorro.

Si quieres impresionar: cambia `TREE_COUNT` a `1_000_000` y vuelve a ejecutar.
Los tipos siguen siendo 4; el ahorro crece.

---

## Slide 12 — Cuadro comparativo de los 7 patrones

> «Este es el resumen. Léanlo como tabla de decisión: la segunda columna dice qué
> hace y la tercera cuándo aparece.»

Recorre rápido, sin leer cada fila completa:

- **Adapter** adapta una interfaz que no encaja.
- **Bridge** separa dos ejes de cambio.
- **Composite** arma árboles parte-todo.
- **Decorator** envuelve para sumar comportamiento.
- **Facade** simplifica un subsistema.
- **Flyweight** comparte estado inmutable.
- **Proxy** controla el acceso.

**Frase:** «No son excluyentes: un sistema real usa varios a la vez.»

---

## Slide 13 — ¿Cuál elijo? Guía rápida

> «Si les queda una sola cosa, que sea esta guía. Empiecen por la señal del
> problema, no por el nombre del patrón.»

Lee las preguntas de la izquierda y deja que el público complete el patrón, o
resuélvelas tú en 30 segundos. Cierra con la regla práctica: «si no puedes
nombrar el problema, no apliques el patrón».

---

## Slide 14 — Cierre

> «Tres ideas: **composición sobre herencia**, **Bridge desacopla** dos
> jerarquías y **Flyweight comparte** lo inmutable. El código, las pruebas y esta
> presentación están en el repositorio. Gracias, ¿preguntas?»

---

## Preguntas frecuentes (y respuestas cortas)

**¿Bridge no es lo mismo que Strategy?**
No. Strategy encapsula un algoritmo intercambiable dentro de un objeto. Bridge
estructura **dos jerarquías completas**: la abstracción y la implementación, y
permite que ambas crezcan por separado.

**¿Bridge no es lo mismo que Adapter?**
Adapter arregla una incompatibilidad que ya existe. Bridge separa dos
dimensiones **desde el diseño**, antes de que la explosión de subclases ocurra.

**¿Flyweight no es un Singleton?**
Singleton garantiza **una** instancia global. Flyweight garantiza **una
instancia por clave** (por ejemplo, una por especie y color).

**¿Por qué no usar un `static` o un cache global?**
La fábrica encapsula la clave, el ciclo de vida y la creación. Un global oculta
dependencias y complica las pruebas. La fábrica se puede inyectar y testear.

**¿Y la seguridad entre hilos?**
`HashMap` no es seguro entre hilos. En producción usa `ConcurrentHashMap` y
`computeIfAbsent`, y mantén los flyweights inmutables.

**¿La memoria de la demo es real?**
Es una estimación didáctica: costo fijo por objeto más el tamaño de la textura.
Lo importante es el orden de magnitud: 4 texturas en vez de 200.000.

**¿Cuándo NO usar Flyweight?**
Cuando hay pocos objetos, cuando el estado compartido necesita cambiar o cuando
no se puede separar limpiamente lo intrínseco de lo extrínseco.

**¿Por qué el ejemplo de Bridge usa figuras y no algo de negocio?**
Porque el diagrama se entiende sin contexto. El mismo patrón aplica a JDBC, a
notificaciones (tipo × canal) o a reproductores (contenido × códec).

---

## Checklist antes de exponer

- [ ] Nombres completos en la slide 1.
- [ ] PPTX abierto una vez para verificar fuentes (Segoe UI / Consolas).
- [ ] PDF de respaldo en el escritorio o USB.
- [ ] Probar la demo: `cd flyweight && mvn test && mvn compile exec:java`.
- [ ] Terminal con fuente grande y fondo oscuro para la demo.
- [ ] HDMI/proyector en 16:9.
- [ ] Ensayo cronometrado: 11–13 minutos.
