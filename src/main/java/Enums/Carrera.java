package Enums;

public enum Carrera {
    INGENIERIA_DE_SISTEMAS("Ingeniería de Sistemas"),
    INGENIERIA_DE_COMPUTACION("Ingeniería de Computación"),
    INGENIERIA_EN_CIBERSEGURIDAD("Ingeniería en Ciberseguridad"),
    INGENIERIA_EN_TIC("Ingeniería en TIC");

    private final String nombre;

    Carrera(String nombre) {
        this.nombre = nombre;
    }

    public String getNombre() {
        return nombre;
    }
}
