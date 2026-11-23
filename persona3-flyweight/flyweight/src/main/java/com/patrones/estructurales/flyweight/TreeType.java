package com.patrones.estructurales.flyweight;

/**
 * FLYWEIGHT: estado intrinseco compartido.
 *
 * Es inmutable y se reutiliza entre miles de arboles. Guarda lo que es
 * igual para todos los arboles de la misma especie: nombre, color y textura.
 */
public final class TreeType {

    private final String species;
    private final String color;
    private final byte[] texture;

    /** Constructor a nivel de paquete: solo la fabrica crea flyweights. */
    TreeType(String species, String color, byte[] texture) {
        this.species = species;
        this.color = color;
        this.texture = texture.clone();
    }

    /** Estado extrinseco: la posicion la aporta el objeto Tree en cada dibujo. */
    public String render(int x, int y) {
        return String.format("%s %s en (%d, %d) [textura %d B]",
                species, color, x, y, texture.length);
    }

    public String getSpecies() {
        return species;
    }

    public String getColor() {
        return color;
    }

    public int textureBytes() {
        return texture.length;
    }
}
