package com.patrones.estructurales.flyweight;

import java.util.HashMap;
import java.util.Map;
import java.util.function.Supplier;

/**
 * FLYWEIGHT FACTORY: cache de flyweights.
 *
 * Garantiza que exista UNA sola instancia de TreeType por combinacion
 * especie + color. Si el tipo ya existe, devuelve la instancia compartida;
 * si no, la crea una vez y la guarda.
 */
public class TreeFactory {

    private final Map<String, TreeType> cache = new HashMap<>();
    private int cacheHits;

    public TreeType getTreeType(String species, String color, Supplier<byte[]> textureLoader) {
        String key = species + "|" + color;
        TreeType existing = cache.get(key);
        if (existing != null) {
            cacheHits++;
            return existing;
        }
        TreeType created = new TreeType(species, color, textureLoader.get());
        cache.put(key, created);
        return created;
    }

    /** Cantidad de flyweights realmente creados. */
    public int typeCount() {
        return cache.size();
    }

    /** Veces que se reutilizo un flyweight en lugar de crearlo. */
    public int cacheHits() {
        return cacheHits;
    }
}
