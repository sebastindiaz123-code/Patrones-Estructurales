package com.patrones.estructurales.flyweight;

import java.util.List;
import java.util.Random;

/**
 * Demostracion completa del patron Flyweight.
 *
 * Se plantan 200.000 arboles de solo 4 tipos. Sin Flyweight cada arbol
 * cargaria su propia textura (2 KB); con Flyweight la textura se comparte
 * y cada arbol solo guarda su posicion y una referencia al tipo.
 */
public final class Main {

    private static final int TREE_COUNT = 200_000;
    private static final int TEXTURE_BYTES = 2_048;
    private static final int NAIVE_TREE_OVERHEAD = 64;
    private static final int FLYWEIGHT_TREE_OVERHEAD = 40;

    private static final String[][] TYPES = {
            {"Roble", "verde"},
            {"Pino", "oscuro"},
            {"Sauce", "claro"},
            {"Cerezo", "rosa"}
    };

    private Main() {
    }

    public static void main(String[] args) {
        TreeFactory factory = new TreeFactory();
        Forest forest = new Forest(factory);
        Random random = new Random(42);

        for (int i = 0; i < TREE_COUNT; i++) {
            String[] type = TYPES[random.nextInt(TYPES.length)];
            forest.plant(
                    random.nextInt(10_000),
                    random.nextInt(10_000),
                    type[0],
                    type[1],
                    () -> new byte[TEXTURE_BYTES]
            );
        }

        System.out.println("=== Bosque con Flyweight ===");
        System.out.println("Arboles plantados : " + forest.size());
        System.out.println("Tipos creados     : " + factory.typeCount() + " (una vez por especie)");
        System.out.println("Reutilizaciones   : " + factory.cacheHits());
        System.out.println();

        System.out.println("=== Primeros 5 arboles (estado extrinseco + intrinseco) ===");
        List<String> sample = forest.renderSample(5);
        sample.forEach(line -> System.out.println("  " + line));
        System.out.println();

        double naiveMb = estimateNaiveMb();
        double flyweightMb = estimateFlyweightMb(factory.typeCount());
        System.out.println("=== Memoria estimada de texturas ===");
        System.out.printf("Sin Flyweight (200.000 texturas) : %8.2f MB%n", naiveMb);
        System.out.printf("Con Flyweight (solo 4 texturas)  : %8.2f MB%n", flyweightMb);
        System.out.printf("Ahorro                           : %8.2f%%%n",
                (1 - flyweightMb / naiveMb) * 100);
    }

    private static double estimateNaiveMb() {
        long bytes = (long) TREE_COUNT * (TEXTURE_BYTES + NAIVE_TREE_OVERHEAD);
        return bytes / 1024.0 / 1024.0;
    }

    private static double estimateFlyweightMb(int typeCount) {
        long bytes = (long) typeCount * (TEXTURE_BYTES + NAIVE_TREE_OVERHEAD)
                + (long) TREE_COUNT * FLYWEIGHT_TREE_OVERHEAD;
        return bytes / 1024.0 / 1024.0;
    }
}
