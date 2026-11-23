package com.patrones.estructurales.composite;

/**
 * COMPONENTE: interfaz común para archivos y carpetas.
 * Gracias a ella, el cliente trata igual un elemento simple (Archivo)
 * y uno compuesto (Carpeta).
 */
public interface ElementoSistema {
    String getNombre();

    /** Tamaño en KB. */
    long getTamano();

    /** Imprime el elemento con la sangría indicada (para dibujar el árbol). */
    void mostrar(String sangria);
}