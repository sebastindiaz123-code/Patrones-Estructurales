package com.patrones.estructurales.bridge;

import java.util.List;

/**
 * Demostracion del patron Bridge.
 *
 * Las mismas figuras se dibujan con dos tecnologias distintas sin crear
 * una subclase por cada combinacion (CircleVector, CircleRaster, ...).
 */
public final class Main {

    private Main() {
    }

    public static void main(String[] args) {
        Renderer vector = new VectorRenderer();
        Renderer raster = new RasterRenderer();

        System.out.println("=== Mismas figuras, dos renderizadores ===");
        for (Shape shape : shapes(vector)) {
            print(shape, "vectorial");
        }
        for (Shape shape : shapes(raster)) {
            print(shape, "raster");
        }

        System.out.println();
        System.out.println("=== Un renderizador nuevo no toca las figuras ===");
        Renderer ascii = new AsciiRenderer();
        for (Shape shape : shapes(ascii)) {
            print(shape, "ascii");
        }
    }

    private static List<Shape> shapes(Renderer renderer) {
        return List.of(
                new Circle(5, renderer),
                new Square(4, renderer),
                new Circle(1.5, renderer)
        );
    }

    private static void print(Shape shape, String technology) {
        System.out.printf("%-10s | %-34s | area = %7.2f%n",
                technology, shape.draw(), shape.area());
    }

    /** Tercer implementor agregado despues, sin tocar Shape, Circle ni Square. */
    private static final class AsciiRenderer implements Renderer {

        @Override
        public String circle(double radius) {
            return String.format("( ) circulo ascii r=%.1f", radius);
        }

        @Override
        public String square(double side) {
            return String.format("[ ] cuadrado ascii lado=%.1f", side);
        }
    }
}
