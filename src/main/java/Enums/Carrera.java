package Enums;

/**
 * Carreras FIS usadas para filtrar el plan de materias (tutor y registro de estudiante).
 */
public enum Carrera {
    SOFTWARE("Software"),
    COMPUTACION("Computación"),
    CIENCIA_DATOS_IA("Ciencia de Datos e Inteligencia Artificial"),
    SISTEMAS_INFORMACION("Sistemas de Información");

    private final String nombre;

    Carrera(String nombre) {
        this.nombre = nombre;
    }

    public String getNombre() {
        return nombre;
    }
}
