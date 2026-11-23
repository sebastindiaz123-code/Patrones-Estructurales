package com.patrones.estructurales.flyweight;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotSame;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.concurrent.atomic.AtomicInteger;
import org.junit.jupiter.api.Test;

class FlyweightTest {

    private static final int TEXTURE_BYTES = 128;

    @Test
    void laFabricaComparteElMismoTipoParaLaMismaClave() {
        TreeFactory factory = new TreeFactory();

        TreeType first = factory.getTreeType("Roble", "verde", () -> new byte[TEXTURE_BYTES]);
        TreeType second = factory.getTreeType("Roble", "verde", () -> new byte[TEXTURE_BYTES]);

        assertSame(first, second);
        assertEquals(1, factory.typeCount());
        assertEquals(1, factory.cacheHits());
    }

    @Test
    void tiposConDistintaClaveNoSeComparten() {
        TreeFactory factory = new TreeFactory();

        TreeType oak = factory.getTreeType("Roble", "verde", () -> new byte[TEXTURE_BYTES]);
        TreeType pine = factory.getTreeType("Pino", "oscuro", () -> new byte[TEXTURE_BYTES]);

        assertNotSame(oak, pine);
        assertEquals(2, factory.typeCount());
    }

    @Test
    void laTexturaSoloSeCargaUnaVezPorTipo() {
        TreeFactory factory = new TreeFactory();
        AtomicInteger loads = new AtomicInteger();

        for (int i = 0; i < 1_000; i++) {
            factory.getTreeType("Cerezo", "rosa", () -> {
                loads.incrementAndGet();
                return new byte[TEXTURE_BYTES];
            });
        }

        assertEquals(1, loads.get());
        assertEquals(999, factory.cacheHits());
    }

    @Test
    void elBosqueGuardaMuchosArbolesConPocosTipos() {
        TreeFactory factory = new TreeFactory();
        Forest forest = new Forest(factory);

        for (int i = 0; i < 5_000; i++) {
            forest.plant(i, i * 2, "Pino", "oscuro", () -> new byte[TEXTURE_BYTES]);
        }

        assertEquals(5_000, forest.size());
        assertEquals(1, factory.typeCount());
        assertSame(factory.getTreeType("Pino", "oscuro", () -> new byte[TEXTURE_BYTES]),
                forest.getTrees().get(0).getType());
    }

    @Test
    void cadaArbolAportaSuPropiaPosicion() {
        TreeFactory factory = new TreeFactory();
        Forest forest = new Forest(factory);
        forest.plant(3, 7, "Sauce", "claro", () -> new byte[TEXTURE_BYTES]);
        forest.plant(10, 20, "Sauce", "claro", () -> new byte[TEXTURE_BYTES]);

        String first = forest.getTrees().get(0).render();
        String second = forest.getTrees().get(1).render();

        assertTrue(first.contains("(3, 7)"));
        assertTrue(second.contains("(10, 20)"));
        assertTrue(first.contains("Sauce claro"));
    }
}
