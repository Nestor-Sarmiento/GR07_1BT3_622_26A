package Enums;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

/**
 * Une las materias por carrera ({@link MateriaSoftware}, etc.) y expone búsqueda por código SIGLA.
 */
public final class MateriasCatalogo {

    private MateriasCatalogo() {
    }

    public static final class Opcion {
        private final String codigo;
        private final String nombre;
        private final int semestre;
        private final Carrera carrera;

        public Opcion(String codigo, String nombre, int semestre, Carrera carrera) {
            this.codigo = codigo;
            this.nombre = nombre;
            this.semestre = semestre;
            this.carrera = carrera;
        }

        public String getCodigo() {
            return codigo;
        }

        public String getNombre() {
            return nombre;
        }

        public int getSemestre() {
            return semestre;
        }

        public Carrera getCarrera() {
            return carrera;
        }
    }

    /**
     * Asignaturas que un tutor puede ofrecer: solo las de semestres estrictamente menores al semestre
     * en que cursa (ej. 5º semestre → puede dar 1–4). Si {@code semestreTutor} es null (datos viejos),
     * no se aplica tope (compatibilidad).
     */
    public static List<Opcion> porCarreraParaTutor(Carrera carrera, Semestre semestreTutor) {
        if (carrera == null) {
            return List.of();
        }
        int topeExclusivo = semestreTutor == null ? Integer.MAX_VALUE : semestreTutor.getNumero();
        return porCarrera(carrera).stream()
                .filter(o -> o.getSemestre() < topeExclusivo)
                .toList();
    }

    public static boolean codigoPermitidoParaTutor(Carrera carrera, Semestre semestreTutor, String codigo) {
        if (codigo == null || codigo.isBlank() || carrera == null) {
            return false;
        }
        String norm = codigo.trim();
        return porCarreraParaTutor(carrera, semestreTutor).stream()
                .anyMatch(o -> o.getCodigo().equalsIgnoreCase(norm));
    }

    public static List<Opcion> porCarrera(Carrera c) {
        if (c == null) {
            return List.of();
        }
        return switch (c) {
            case SOFTWARE -> Arrays.stream(MateriaSoftware.values())
                    .map(m -> new Opcion(m.getId(), m.getNombre(), m.getSemestre(), c))
                    .toList();
            case SISTEMAS_INFORMACION -> Arrays.stream(MateriaSistemasInformacion.values())
                    .map(m -> new Opcion(m.getId(), m.getNombre(), m.getSemestre(), c))
                    .toList();
            case CIENCIA_DATOS_IA -> Arrays.stream(MateriaCienciaDatosIA.values())
                    .map(m -> new Opcion(m.getId(), m.getNombre(), m.getSemestre(), c))
                    .toList();
            case COMPUTACION -> Arrays.stream(MateriaComputacion.values())
                    .map(m -> new Opcion(m.getId(), m.getNombre(), m.getSemestre(), c))
                    .toList();
        };
    }

    public static Optional<Opcion> buscarPorCodigo(String codigo) {
        if (codigo == null || codigo.isBlank()) {
            return Optional.empty();
        }
        String norm = codigo.trim();
        for (Carrera car : Carrera.values()) {
            for (Opcion o : porCarrera(car)) {
                if (o.getCodigo().equalsIgnoreCase(norm)) {
                    return Optional.of(o);
                }
            }
        }
        return Optional.empty();
    }

    /** Lista para el buscador del estudiante: una entrada por código (sin duplicar). */
    public static List<Opcion> todasOpcionesBusqueda() {
        Map<String, Opcion> map = new LinkedHashMap<>();
        for (Carrera car : Carrera.values()) {
            for (Opcion o : porCarrera(car)) {
                map.putIfAbsent(o.getCodigo().toUpperCase(Locale.ROOT), o);
            }
        }
        List<Opcion> list = new ArrayList<>(map.values());
        list.sort(Comparator.comparing(Opcion::getNombre, String.CASE_INSENSITIVE_ORDER));
        return list;
    }

    public static boolean codigoPerteneceACarrera(String codigo, Carrera carrera) {
        if (codigo == null || codigo.isBlank() || carrera == null) {
            return false;
        }
        String norm = codigo.trim();
        return porCarrera(carrera).stream().anyMatch(o -> o.getCodigo().equalsIgnoreCase(norm));
    }

    /**
     * Convierte el nombre de constante del antiguo modelo (tabla {@code tutor_materias_fis}, p. ej.
     * {@code PROGRAMACION_II}) al código SIGLA usado hoy ({@code ICCD244}). Los cuatro planes comparten
     * los mismos nombres de constante para la mayoría de asignaturas comunes.
     */
    public static Optional<String> codigoPorNombreConstanteLegacy(String nombreConstanteEnum) {
        if (nombreConstanteEnum == null || nombreConstanteEnum.isBlank()) {
            return Optional.empty();
        }
        String name = nombreConstanteEnum.trim();
        Optional<String> c = codigoDesdeEnumSoftware(name);
        if (c.isPresent()) {
            return c;
        }
        c = codigoDesdeEnumComputacion(name);
        if (c.isPresent()) {
            return c;
        }
        c = codigoDesdeEnumCienciaDatos(name);
        if (c.isPresent()) {
            return c;
        }
        return codigoDesdeEnumSistemasInfo(name);
    }

    private static Optional<String> codigoDesdeEnumSoftware(String name) {
        try {
            return Optional.of(MateriaSoftware.valueOf(name).getId());
        } catch (IllegalArgumentException e) {
            return Optional.empty();
        }
    }

    private static Optional<String> codigoDesdeEnumComputacion(String name) {
        try {
            return Optional.of(MateriaComputacion.valueOf(name).getId());
        } catch (IllegalArgumentException e) {
            return Optional.empty();
        }
    }

    private static Optional<String> codigoDesdeEnumCienciaDatos(String name) {
        try {
            return Optional.of(MateriaCienciaDatosIA.valueOf(name).getId());
        } catch (IllegalArgumentException e) {
            return Optional.empty();
        }
    }

    private static Optional<String> codigoDesdeEnumSistemasInfo(String name) {
        try {
            return Optional.of(MateriaSistemasInformacion.valueOf(name).getId());
        } catch (IllegalArgumentException e) {
            return Optional.empty();
        }
    }

    public static String toJsonPorCarrera() {
        StringBuilder sb = new StringBuilder();
        sb.append('{');
        boolean firstC = true;
        for (Carrera c : Carrera.values()) {
            if (!firstC) {
                sb.append(',');
            }
            firstC = false;
            sb.append('"').append(c.name()).append("\":[");
            List<Opcion> ops = porCarrera(c);
            for (int i = 0; i < ops.size(); i++) {
                Opcion o = ops.get(i);
                if (i > 0) {
                    sb.append(',');
                }
                sb.append("{\"codigo\":\"").append(escapeJson(o.getCodigo())).append("\",\"nombre\":\"")
                        .append(escapeJson(o.getNombre())).append("\",\"semestre\":").append(o.getSemestre()).append('}');
            }
            sb.append(']');
        }
        sb.append('}');
        return sb.toString();
    }

    private static String escapeJson(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\r", " ").replace("\n", " ");
    }
}
