package com.patrones.estructurales.composite;

/**
 * HOJA: elemento simple del árbol. No contiene otros elementos;
 * simplemente devuelve su propio tamaño.
 */
public class Archivo implements ElementoSistema {
    private final String nombre;
    private final long tamano;

    public Archivo(String nombre, long tamano) {
        this.nombre = nombre;
        this.tamano = tamano;
    }

    @Override
    public String getNombre() {
        return nombre;
    }

    @Override
    public long getTamano() {
        return tamano;
    }

    @Override
    public void mostrar(String sangria) {
        System.out.println(sangria + "- " + nombre + " (" + tamano + " KB)");
    }
}
