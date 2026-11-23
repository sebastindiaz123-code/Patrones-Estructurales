package com.patrones.estructurales.bridge;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

class BridgeTest {

    @Test
    void elMismoCirculoSeDibujaConDosTecnologias() {
        double radius = 3;

        Circle withVector = new Circle(radius, new VectorRenderer());
        Circle withRaster = new Circle(radius, new RasterRenderer());

        assertTrue(withVector.draw().contains("vectorial"));
        assertTrue(withRaster.draw().contains("rasterizado"));
        assertEquals(withVector.area(), withRaster.area(), 0.0001);
    }

    @Test
    void elAreaNoDependeDelRenderizador() {
        assertEquals(Math.PI * 16, new Circle(4, new VectorRenderer()).area(), 0.0001);
        assertEquals(25, new Square(5, new RasterRenderer()).area(), 0.0001);
    }

    @Test
    void laAbstraccionDelegaEnElImplementor() {
        RendererSpy spy = new RendererSpy();
        Shape shape = new Square(2, spy);

        shape.draw();

        assertEquals(1, spy.calls);
        assertEquals(2, spy.lastSide, 0.0001);
    }

    @Test
    void noSePuedenCrearFigurasInvalidas() {
        assertThrows(IllegalArgumentException.class, () -> new Circle(0, new VectorRenderer()));
        assertThrows(IllegalArgumentException.class, () -> new Square(-1, new VectorRenderer()));
    }

    /** Implementor de prueba: comprueba que Shape solo conoce la interfaz. */
    private static final class RendererSpy implements Renderer {

        private int calls;
        private double lastSide;

        @Override
        public String circle(double radius) {
            return "circulo";
        }

        @Override
        public String square(double side) {
            calls++;
            lastSide = side;
            return "cuadrado";
        }
    }
}
