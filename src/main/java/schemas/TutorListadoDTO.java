package schemas;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

/** Vista resumida de un tutor para listados (ej. búsqueda por estudiante). */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TutorListadoDTO {
    private Long idTutor;
    private String nombreMostrar;
    /** Biografía corta o texto por defecto. */
    private String bioCorta;
    @Builder.Default
    private List<String> materiasEtiquetas = new ArrayList<>();

    public String getInicial() {
        if (nombreMostrar == null || nombreMostrar.isBlank()) {
            return "?";
        }
        return nombreMostrar.substring(0, 1).toUpperCase();
    }
}
