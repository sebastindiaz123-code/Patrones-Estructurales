public class Main {
    public static void main(String[] args) {
        
        Reproductor reproductor = new AdaptadorMp4();
        escuchar(reproductor, "cancion.mp4");
        escuchar(reproductor, "video.mp4");
    }

    static void escuchar(Reproductor r, String archivo) {
        r.reproducir(archivo);
    }
}
