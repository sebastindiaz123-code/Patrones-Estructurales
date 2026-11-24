public class MainDecorator {
    public static void main(String[] args) {
        
        Bebida pedido1 = new Cafe();
        imprimir(pedido1);

        
        Bebida pedido2 = new Chocolate(new Crema(new Leche(new Cafe())));
        imprimir(pedido2);

        
        Bebida pedido3 = new Leche(new Leche(new Cafe()));
        imprimir(pedido3);
    }

    static void imprimir(Bebida bebida) {
        System.out.printf("%s = $%.0f COP%n", bebida.getDescripcion(), bebida.getPrecio());
    }
}
