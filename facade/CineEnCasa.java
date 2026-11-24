
public class CineEnCasa {
    private final Luces luces = new Luces();
    private final Sonido sonido = new Sonido();
    private final Proyector proy = new Proyector();

    public void verPelicula(String peli) {
        System.out.println("=== Preparando la película ===");
        luces.atenuar();
        sonido.encender();
        proy.proyectar(peli);
    }

    public void terminar() {
        System.out.println("=== Fin de la película ===");
        proy.apagar();
        sonido.apagar();
        luces.encender();
    }
}
