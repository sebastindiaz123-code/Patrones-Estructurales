package com.patrones.estructurales.proxy;

import java.util.HashMap;
import java.util.Map;

/**
 * PROXY DE CACHÉ: tiene la misma interfaz que el servicio real.
 * Guarda las respuestas ya obtenidas; si la ciudad ya se consultó,
 * responde desde memoria sin llamar a la API remota.
 */
public class ClimaCacheProxy implements ServicioClima {
    private final ServicioClima servicio; // referencia al objeto real
    private final Map<String, String> cache = new HashMap<>();

    public ClimaCacheProxy(ServicioClima servicio) {
        this.servicio = servicio;
    }

    @Override
    public String obtenerClima(String ciudad) {
        if (cache.containsKey(ciudad)) {
            System.out.println("   [Proxy] " + ciudad + " encontrado en caché.");
            return cache.get(ciudad);
        }
        System.out.println("   [Proxy] " + ciudad + " no está en caché, delego al servicio real.");
        String resultado = servicio.obtenerClima(ciudad); // delega
        cache.put(ciudad, resultado);
        return resultado;
    }

    public void limpiarCache() {
        cache.clear();
    }
}