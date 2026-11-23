package com.patrones.estructurales.proxy;

/**
 * INTERFAZ DE SERVICIO: la comparten el servicio real y el proxy.
 * El cliente solo conoce esta interfaz, por eso no nota la diferencia.
 */
public interface ServicioClima {
    String obtenerClima(String ciudad);
}