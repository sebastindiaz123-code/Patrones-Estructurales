package com.patrones.estructurales.bridge;

/** Abstraction refinada: un cuadrado. */
public class Square extends Shape {

    private final double side;

    public Square(double side, Renderer renderer) {
        super(renderer);
        if (side <= 0) {
            throw new IllegalArgumentException("El lado debe ser positivo");
        }
        this.side = side;
    }

    @Override
    public String draw() {
        return renderer.square(side);
    }

    @Override
    public double area() {
        return side * side;
    }

    public double getSide() {
        return side;
    }
}
