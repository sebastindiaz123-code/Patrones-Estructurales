package com.patrones.estructurales.proxy;

/**
 * CLIENTE: una app que consulta el clima varias veces. Recibe un ServicioClima
 * y no sabe si es la API directa o el proxy con caché.
 */
public class Main {
    public static void main(String[] args) {
        String[] consultas = {"Cali", "Bogotá", "Cali", "Medellín", "Cali", "Bogotá"};

        System.out.println("=== SIN proxy ===");
        ApiClimaRemota apiSinProxy = new ApiClimaRemota();
        long t1 = medir(apiSinProxy, consultas);
        System.out.println("Llamadas a la API: " + apiSinProxy.getLlamadas() + " | Tiempo: " + t1 + " ms");

        System.out.println("\n=== CON proxy de caché ===");
        ApiClimaRemota api = new ApiClimaRemota();
        ServicioClima conProxy = new ClimaCacheProxy(api);
        long t2 = medir(conProxy, consultas);
        System.out.println("Llamadas a la API: " + api.getLlamadas() + " | Tiempo: " + t2 + " ms");
    }

    // Recibe cualquier ServicioClima: funciona igual con la API real o con el proxy.
    private static long medir(ServicioClima servicio, String[] ciudades) {
        long inicio = System.currentTimeMillis();
        for (String c : ciudades) {
            System.out.println(c + " -> " + servicio.obtenerClima(c));
        }
        return System.currentTimeMillis() - inicio;
    }
}
