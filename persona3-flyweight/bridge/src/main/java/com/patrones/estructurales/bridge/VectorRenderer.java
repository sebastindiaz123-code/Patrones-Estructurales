package com.patrones.estructurales.bridge;

/** Implementacion concreta del implementor: dibujo vectorial. */
public class VectorRenderer implements Renderer {

    @Override
    public String circle(double radius) {
        return String.format("Circulo vectorial (r=%.1f)", radius);
    }

    @Override
    public String square(double side) {
        return String.format("Cuadrado vectorial (lado=%.1f)", side);
    }
}
