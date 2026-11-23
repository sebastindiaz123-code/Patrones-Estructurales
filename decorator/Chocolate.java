
public class Chocolate extends DecoradorBebida {
    public Chocolate(Bebida bebida) { super(bebida); }

    @Override
    public String getDescripcion() { return bebida.getDescripcion() + " + chocolate"; }

    @Override
    public double getPrecio() { return bebida.getPrecio() + 2000; }
}
