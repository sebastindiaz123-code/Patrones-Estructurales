# Patrón Proxy — Caché para una API de clima

**Autor:** Santiago Alonso · Grupo 7 — Patrones estructurales

## ¿Qué es?
Proxy es un patrón estructural que ofrece un **sustituto** de otro objeto. El proxy tiene
**la misma interfaz** que el objeto real, controla el acceso a él y puede hacer algo antes
o después de pasarle la petición.

## Problema
Una app consulta el clima a una API remota lenta (0,8 s por llamada). Muchas consultas se
repiten, y cada una gasta tiempo de red. Además, la clase de la API es de terceros y no se
puede modificar.

## Solución
`ClimaCacheProxy` implementa la misma interfaz `ServicioClima` que la API real. Antes de
delegar, busca la ciudad en un `HashMap`:
- Si ya está, responde al instante desde la caché.
- Si no, llama a la API real, guarda el resultado y lo devuelve.

El cliente no cambia: recibe un `ServicioClima` y no sabe si es la API o el proxy.

## Roles del patrón

| Rol                  | Clase             | Qué hace                                   |
|----------------------|-------------------|--------------------------------------------|
| Interfaz de servicio | `ServicioClima`   | Contrato común del servicio y el proxy     |
| Servicio             | `ApiClimaRemota`  | API lenta con la lógica real               |
| Proxy                | `ClimaCacheProxy` | Guarda respuestas y delega solo si hace falta |
| Cliente              | `Main`            | Usa todo a través de `ServicioClima`       |

```
Cliente ──► «interfaz» ServicioClima ◄─── ApiClimaRemota
                    ▲                          ▲
                    |                          | delega
             ClimaCacheProxy ──────────────────┘
             - cache: Map
```

## Cómo ejecutarlo
- **VS Code:** abre `Main.java` y dale **Run**.
- **Maven:** desde esta carpeta:
  ```bash
  mvn compile exec:java   # ejecuta el Main
  mvn test                # corre las 5 pruebas
  ```

## Resultado
| | Llamadas a la API | Tiempo aprox. |
|---|---|---|
| Sin proxy | 6 | 4,8 s |
| Con proxy de caché | 3 | 2,4 s |

## Qué observar
- `medir()` recibe un `ServicioClima`: funciona igual con la API real o con el proxy.
- La clase `ApiClimaRemota` no se modificó; toda la lógica extra vive en el proxy.
- Se pueden crear otros proxies (de protección, de registro) sin tocar el servicio ni el
  cliente (principio abierto/cerrado).
- Limitación: esta caché nunca expira; en un caso real se le pondría un tiempo de vida (TTL).

## Tipos de proxy
Virtual (carga diferida), de protección (permisos), remoto, de registro, **de caché** (este
ejemplo) y referencia inteligente.

## Ventajas y desventajas
- ✓ Controla el objeto real sin que el cliente lo note.
- ✓ Se agregan nuevos proxies sin tocar el servicio ni el cliente.
- ✗ Más clases y la respuesta puede tardar un poco por el paso intermedio.

Referencia: https://refactoring.guru/es/design-patterns/proxy