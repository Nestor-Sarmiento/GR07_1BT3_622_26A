package schemas;

import Enums.MateriaFIS;

import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * Construye {@link TutorListadoDTO} a partir de {@link Tutor} para listados (búsqueda, etc.).
 */
public final class TutorListadoMapper {

    private static final int BIO_MAX = 140;

    private TutorListadoMapper() {
    }

    public static TutorListadoDTO toDto(Tutor t) {
        String nombre = joinNombreParts(t.getNombre(), t.getSegundoNombre(), t.getApellido(), t.getSegundoApellido());
        String bio = t.getDescripcionProfesional();
        if (bio != null) {
            bio = bio.trim();
            if (bio.length() > BIO_MAX) {
                bio = bio.substring(0, BIO_MAX - 1) + "…";
            }
        }
        if (bio == null || bio.isEmpty()) {
            bio = "Tutor académico";
        }
        List<String> tags = t.getMateriasRelacionadas() == null ? List.of()
                : t.getMateriasRelacionadas().stream()
                .sorted(Comparator.comparing(MateriaFIS::getNombre))
                .map(MateriaFIS::getNombre)
                .collect(Collectors.toList());
        return TutorListadoDTO.builder()
                .idTutor(t.getId())
                .nombreMostrar(nombre.isEmpty() ? "Tutor" : nombre)
                .bioCorta(bio)
                .materiasEtiquetas(tags)
                .build();
    }

    public static String joinNombreParts(String... parts) {
        if (parts == null) {
            return "";
        }
        return java.util.Arrays.stream(parts)
                .filter(Objects::nonNull)
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .collect(Collectors.joining(" "));
    }
}
