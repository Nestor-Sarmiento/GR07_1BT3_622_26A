package schemas;

import Enums.EstadoMaterial;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "materiales")
public class Material {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_material")
    private Long id;

    @Column(name = "nombre_archivo", nullable = false)
    private String nombreArchivo;

    @Column(name = "titulo", nullable = false)
    private String titulo;

    @Column(name = "id_materia", nullable = false)
    private Long idMateria;

    @Column(name = "nombre_materia", nullable = false)
    private String nombreMateria;

    @Column(name = "usuario_subio", nullable = false)
    private String usuario;

    @Column(name = "descripcion", columnDefinition = "TEXT")
    private String descripcion;

    @Column(name = "tipo_archivo", nullable = false)
    private String tipoArchivo;

    @Column(name = "fecha_envio", nullable = false)
    @Builder.Default
    private LocalDateTime fechaEnvio = LocalDateTime.now();

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private EstadoMaterial estado = EstadoMaterial.PENDIENTE;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal costo;

    @PrePersist
    void prePersist() {
        if (fechaEnvio == null) {
            fechaEnvio = LocalDateTime.now();
        }
        if (estado == null) {
            estado = EstadoMaterial.PENDIENTE;
        }
    }
}

