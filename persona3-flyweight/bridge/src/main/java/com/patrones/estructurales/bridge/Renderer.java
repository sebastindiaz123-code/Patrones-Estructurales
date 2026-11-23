package com.patrones.estructurales.bridge;

/**
 * Implementor del patron Bridge.
 *
 * Define COMO se dibuja una figura. No sabe que figura concreta lo usa.
 * Puede crecer con nuevas tecnologias (vectorial, raster, SVG, 3D...)
 * sin modificar la jerarquia de figuras.
 */
public interface Renderer {

    String circle(double radius);

    String square(double side);
}
