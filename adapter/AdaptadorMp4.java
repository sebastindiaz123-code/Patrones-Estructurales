
public class AdaptadorMp4 implements Reproductor {
    private final ServicioMp4 servicio = new ServicioMp4();

    @Override
    public void reproducir(String archivo) {
        servicio.playMp4(archivo); 
    }
}
