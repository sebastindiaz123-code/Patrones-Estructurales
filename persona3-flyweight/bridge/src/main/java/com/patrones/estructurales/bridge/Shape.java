package com.patrones.estructurales.bridge;

/**
 * Abstraction del patron Bridge.
 *
 * Tiene la referencia al implementor (el "puente") y define la parte
 * estable del dominio: toda figura sabe dibujarse y calcular su area.
 */
public abstract class Shape {

    protected final Renderer renderer;

    protected Shape(Renderer renderer) {
        this.renderer = renderer;
    }

    public abstract String draw();

    public abstract double area();
}
