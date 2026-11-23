package com.patrones.estructurales.composite;

import java.util.ArrayList;
import java.util.List;

/**
 * COMPUESTO: elemento que contiene otros elementos (archivos u otras carpetas).
 * No hace el trabajo él mismo: se lo pide a sus hijos y suma los resultados.
 */
public class Carpeta implements ElementoSistema {
    private final String nombre;
    private final List<ElementoSistema> hijos = new ArrayList<>();

    public Carpeta(String nombre) {
        this.nombre = nombre;
    }

    public void agregar(ElementoSistema elemento) {
        hijos.add(elemento);
    }

    public void eliminar(ElementoSistema elemento) {
        hijos.remove(elemento);
    }

    @Override
    public String getNombre() {
        return nombre;
    }

    /**
     * Recursión: cada hijo calcula su tamaño. Si el hijo es otra carpeta,
     * ella a su vez le pregunta a sus hijos, y así hasta llegar a los archivos.
     */
    @Override
    public long getTamano() {
        long total = 0;
        for (ElementoSistema hijo : hijos) {
            total += hijo.getTamano();
        }
        return total;
    }

    @Override
    public void mostrar(String sangria) {
        System.out.println(sangria + "+ " + nombre + "/ (" + getTamano() + " KB)");
        for (ElementoSistema hijo : hijos) {
            hijo.mostrar(sangria + "    ");
        }
    }
}