package com.patrones.estructurales.flyweight;

/**
 * CONTEXTO: el arbol concreto del bosque.
 *
 * Solo guarda el estado extrinseco (x, y) y una REFERENCIA al flyweight.
 * Hay 200.000 de estos objetos, por eso deben ser lo mas livianos posible.
 */
public final class Tree {

    private final int x;
    private final int y;
    private final TreeType type;

    Tree(int x, int y, TreeType type) {
        this.x = x;
        this.y = y;
        this.type = type;
    }

    public String render() {
        return type.render(x, y);
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    public TreeType getType() {
        return type;
    }
}
