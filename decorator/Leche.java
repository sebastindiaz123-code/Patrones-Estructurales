
public class Leche extends DecoradorBebida {
    public Leche(Bebida bebida) { super(bebida); }

    @Override
    public String getDescripcion() { return bebida.getDescripcion() + " + leche"; }

    @Override
    public double getPrecio() { return bebida.getPrecio() + 1000; }
}
