
public class Crema extends DecoradorBebida {
    public Crema(Bebida bebida) { super(bebida); }

    @Override
    public String getDescripcion() { return bebida.getDescripcion() + " + crema"; }

    @Override
    public double getPrecio() { return bebida.getPrecio() + 1500; }
}
