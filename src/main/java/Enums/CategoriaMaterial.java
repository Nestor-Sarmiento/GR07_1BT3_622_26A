package Enums;

public enum CategoriaMaterial {
    GUIA("Guía"),
    APUNTES("Apuntes"),
    EJERCICIOS("Ejercicios"),
    RESUMEN("Resumen"),
    EXAMEN("Examen"),
    PROYECTO("Proyecto"),
    PRACTICAS("Practicas"),
    INFORMES("Informes"),
    DEBERES("Deberes"),
    PRUEBAS("Pruebas");

    private final String nombre;

    CategoriaMaterial(String nombre) {
        this.nombre = nombre;
    }

    public String getNombre() {
        return nombre;
    }
}
