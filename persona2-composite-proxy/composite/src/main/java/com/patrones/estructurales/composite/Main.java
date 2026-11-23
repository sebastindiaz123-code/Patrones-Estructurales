package com.patrones.estructurales.composite;

/**
 * CLIENTE: arma un árbol de carpetas y archivos y calcula tamaños.
 * Nunca pregunta "¿esto es archivo o carpeta?": solo usa la interfaz ElementoSistema.
 */
public class Main {
    public static void main(String[] args) {
        // Hojas
        Archivo readme = new Archivo("README.md", 4);
        Archivo mainJava = new Archivo("Main.java", 12);
        Archivo helper = new Archivo("Helper.java", 8);
        Archivo logo = new Archivo("logo.png", 250);
        Archivo fondo = new Archivo("fondo.jpg", 1200);

        // Compuestos (carpetas dentro de carpetas)
        Carpeta utils = new Carpeta("utils");
        utils.agregar(helper);

        Carpeta src = new Carpeta("src");
        src.agregar(mainJava);
        src.agregar(utils);

        Carpeta imagenes = new Carpeta("imagenes");
        imagenes.agregar(logo);
        imagenes.agregar(fondo);

        Carpeta proyecto = new Carpeta("mi-proyecto");
        proyecto.agregar(readme);
        proyecto.agregar(src);
        proyecto.agregar(imagenes);

        System.out.println("=== Árbol del proyecto ===");
        proyecto.mostrar("");

        System.out.println("\n=== El cliente trata igual archivos y carpetas ===");
        ElementoSistema[] elementos = {readme, utils, imagenes, proyecto};
        for (ElementoSistema e : elementos) {
            imprimirTamano(e);
        }

        System.out.println("\n=== Se borra fondo.jpg ===");
        imagenes.eliminar(fondo);
        imprimirTamano(proyecto);
    }

    // Este método recibe cualquier ElementoSistema: no le importa si es hoja o compuesto.
    private static void imprimirTamano(ElementoSistema elemento) {
        System.out.println(elemento.getNombre() + " -> " + elemento.getTamano() + " KB");
    }
}