
public abstract class DecoradorBebida implements Bebida {
    protected final Bebida bebida;

    protected DecoradorBebida(Bebida bebida) {
        this.bebida = bebida;
    }
}
