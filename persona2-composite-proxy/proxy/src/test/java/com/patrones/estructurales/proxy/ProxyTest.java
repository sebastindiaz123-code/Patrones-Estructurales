package com.patrones.estructurales.proxy;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class ProxyTest {

    @Test
    void sinProxyCadaConsultaLlamaALaApi() {
        ApiClimaRemota api = new ApiClimaRemota(0);

        api.obtenerClima("Cali");
        api.obtenerClima("Cali");
        api.obtenerClima("Cali");

        assertEquals(3, api.getLlamadas());
    }

    @Test
    void conProxyLasConsultasRepetidasSalenDeLaCache() {
        ApiClimaRemota api = new ApiClimaRemota(0);
        ServicioClima proxy = new ClimaCacheProxy(api);

        proxy.obtenerClima("Cali");
        proxy.obtenerClima("Cali");
        proxy.obtenerClima("Cali");

        assertEquals(1, api.getLlamadas());
    }

    @Test
    void elProxyDevuelveLoMismoQueElServicioReal() {
        ApiClimaRemota api = new ApiClimaRemota(0);
        ServicioClima proxy = new ClimaCacheProxy(new ApiClimaRemota(0));

        assertEquals(api.obtenerClima("Bogotá"), proxy.obtenerClima("Bogotá"));
        assertEquals(api.obtenerClima("Bogotá"), proxy.obtenerClima("Bogotá"));
    }

    @Test
    void ciudadesDistintasSeConsultanUnaVezCadaUna() {
        ApiClimaRemota api = new ApiClimaRemota(0);
        ServicioClima proxy = new ClimaCacheProxy(api);
        String[] consultas = {"Cali", "Bogotá", "Cali", "Medellín", "Cali", "Bogotá"};

        for (String c : consultas) {
            proxy.obtenerClima(c);
        }

        assertEquals(3, api.getLlamadas());
    }

    @Test
    void alLimpiarLaCacheSeVuelveAConsultarLaApi() {
        ApiClimaRemota api = new ApiClimaRemota(0);
        ClimaCacheProxy proxy = new ClimaCacheProxy(api);

        proxy.obtenerClima("Cali");
        proxy.limpiarCache();
        proxy.obtenerClima("Cali");

        assertEquals(2, api.getLlamadas());
    }
}