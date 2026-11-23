package com.patrones.estructurales.composite;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class CompositeTest {

    @Test
    void unArchivoDevuelveSuPropioTamano() {
        Archivo archivo = new Archivo("nota.txt", 10);

        assertEquals(10, archivo.getTamano());
    }

    @Test
    void unaCarpetaVaciaPesaCero() {
        Carpeta carpeta = new Carpeta("vacia");

        assertEquals(0, carpeta.getTamano());
    }

    @Test
    void unaCarpetaSumaElTamanoDeSusArchivos() {
        Carpeta carpeta = new Carpeta("docs");
        carpeta.agregar(new Archivo("a.txt", 5));
        carpeta.agregar(new Archivo("b.txt", 7));

        assertEquals(12, carpeta.getTamano());
    }

    @Test
    void elTamanoSeCalculaRecursivamenteEnCarpetasAnidadas() {
        Carpeta utils = new Carpeta("utils");
        utils.agregar(new Archivo("Helper.java", 8));

        Carpeta src = new Carpeta("src");
        src.agregar(new Archivo("Main.java", 12));
        src.agregar(utils);

        Carpeta proyecto = new Carpeta("mi-proyecto");
        proyecto.agregar(new Archivo("README.md", 4));
        proyecto.agregar(src);

        assertEquals(24, proyecto.getTamano());
    }

    @Test
    void alEliminarUnElementoElTotalSeActualiza() {
        Archivo grande = new Archivo("fondo.jpg", 1200);
        Carpeta imagenes = new Carpeta("imagenes");
        imagenes.agregar(new Archivo("logo.png", 250));
        imagenes.agregar(grande);

        imagenes.eliminar(grande);

        assertEquals(250, imagenes.getTamano());
    }

    @Test
    void elClienteTrataIgualArchivosYCarpetas() {
        Carpeta carpeta = new Carpeta("c");
        carpeta.agregar(new Archivo("x", 3));
        ElementoSistema[] elementos = {new Archivo("y", 3), carpeta};

        for (ElementoSistema e : elementos) {
            assertEquals(3, e.getTamano());
        }
    }
}
