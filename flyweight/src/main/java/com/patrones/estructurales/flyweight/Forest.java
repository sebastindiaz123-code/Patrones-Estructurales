package com.patrones.estructurales.flyweight;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Supplier;

/** Bosque: coleccion de arboles (contextos) que comparten flyweights. */
public class Forest {

    private final TreeFactory factory;
    private final List<Tree> trees = new ArrayList<>();

    public Forest(TreeFactory factory) {
        this.factory = factory;
    }

    public Tree plant(int x, int y, String species, String color, Supplier<byte[]> textureLoader) {
        TreeType type = factory.getTreeType(species, color, textureLoader);
        Tree tree = new Tree(x, y, type);
        trees.add(tree);
        return tree;
    }

    public List<Tree> getTrees() {
        return List.copyOf(trees);
    }

    public int size() {
        return trees.size();
    }

    public List<String> renderSample(int amount) {
        return trees.stream()
                .limit(amount)
                .map(Tree::render)
                .toList();
    }
}
