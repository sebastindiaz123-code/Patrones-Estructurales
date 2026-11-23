package com.patrones.estructurales.bridge;

/** Abstraction refinada: un circulo. */
public class Circle extends Shape {

    private final double radius;

    public Circle(double radius, Renderer renderer) {
        super(renderer);
        if (radius <= 0) {
            throw new IllegalArgumentException("El radio debe ser positivo");
        }
        this.radius = radius;
    }

    @Override
    public String draw() {
        return renderer.circle(radius);
    }

    @Override
    public double area() {
        return Math.PI * radius * radius;
    }

    public double getRadius() {
        return radius;
    }
}
