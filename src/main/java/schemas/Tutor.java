package schemas;

import Enums.Carrera;
import Enums.Estados;
import Enums.Semestre;
import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashSet;
import java.util.Set;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "tutores")
public class Tutor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_tutor")
    private Long id;

    private String nombre;
    private String segundoNombre;
    private String apellido;
    private String segundoApellido;

    @Enumerated(EnumType.STRING)
    private Estados estado;

    @Builder.Default
    private boolean mustChangePassword = false;

    @Column(length = 4000)
    private String descripcionProfesional;

    /** Plan FIS del tutor; define de qué catálogo provienen {@link #codigosMateriaRelacionadas}. */
    @Enumerated(EnumType.STRING)
    @Column(name = "carrera")
    private Carrera carrera;

    /** Semestre en que cursa; solo puede ofrecer asignaturas de semestres anteriores. */
    @Enumerated(EnumType.STRING)
    @Column(name = "semestre")
    private Semestre semestre;

    /**
     * Códigos SIGLA de asignaturas (ej. ICCD244), según {@link #carrera}.
     */
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "tutor_materias_codigo", joinColumns = @JoinColumn(name = "id_tutor"))
    @Column(name = "codigo", nullable = false, length = 32)
    @Builder.Default
    private Set<String> codigosMateriaRelacionadas = new HashSet<>();
}
