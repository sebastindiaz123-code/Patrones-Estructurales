package com.patrones.estructurales.bridge;

/** Implementacion concreta del implementor: dibujo rasterizado (pixeles). */
public class RasterRenderer implements Renderer {

    @Override
    public String circle(double radius) {
        return String.format("Circulo rasterizado (r=%.1f px)", radius);
    }

    @Override
    public String square(double side) {
        return String.format("Cuadrado rasterizado (lado=%.1f px)", side);
    }
}
