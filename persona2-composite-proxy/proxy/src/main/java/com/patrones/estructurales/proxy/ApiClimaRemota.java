package com.patrones.estructurales.proxy;

/**
 * SERVICIO REAL: simula una API externa lenta (por ejemplo, de una biblioteca
 * de terceros que no podemos modificar). Cada llamada tarda y "cuesta".
 */
public class ApiClimaRemota implements ServicioClima {
    private final long latenciaMs;
    private int llamadas = 0;

    public ApiClimaRemota() {
        this(800); // latencia por defecto: 0,8 segundos por llamada
    }

    public ApiClimaRemota(long latenciaMs) {
        this.latenciaMs = latenciaMs;
    }

    @Override
    public String obtenerClima(String ciudad) {
        llamadas++;
        System.out.println("   [API] Consultando servidor remoto para " + ciudad + "...");
        try {
            Thread.sleep(latenciaMs); // simula la demora de la red
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        return switch (ciudad) {
            case "Cali" -> "28°C, soleado";
            case "Bogotá" -> "14°C, nublado";
            case "Medellín" -> "24°C, lluvia ligera";
            default -> "sin datos";
        };
    }

    /** Cuántas veces se llamó de verdad a la API (para comparar con y sin proxy). */
    public int getLlamadas() {
        return llamadas;
    }
}
