package Enums;

public enum Semestre {
    PRIMER_SEMESTRE("Primer semestre"),
    SEGUNDO_SEMESTRE("Segundo semestre"),
    TERCER_SEMESTRE("Tercer semestre"),
    CUARTO_SEMESTRE("Cuarto semestre"),
    QUINTO_SEMESTRE("Quinto semestre"),
    SEXTO_SEMESTRE("Sexto semestre"),
    SEPTIMO_SEMESTRE("Séptimo semestre"),
    OCTAVO_SEMESTRE("Octavo semestre"),
    NOVENO_SEMESTRE("Noveno semestre");

    private final String nombre;

    Semestre(String nombre) {
        this.nombre = nombre;
    }

    public String getNombre() {
        return nombre;
    }
}
