package schemas;

import Enums.EstadoMaterial;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "materiales")
public class Material {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_material")
    private Long id;

    @Column(name = "titulo")
    private String titulo;

    @Column(name = "nombre_archivo")
    private String nombreArchivo;

    @Column(name = "descripcion")
    private String descripcion;

    @Column(name = "id_materia")
    private String idMateria;

    @Column(name = "nombre_materia")
    private String nombreMateria;

    @Column(name = "ruta_archivo")
    private String rutaArchivo;

    @Column(name = "tipo_archivo")
    private String tipoArchivo;

    @Column(name = "costo")
    private Double costo;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado")
    private EstadoMaterial estado;

    @Column(name = "fecha_envio")
    private LocalDateTime fechaEnvio;

    @Column(name = "usuario_subio")
    private String usuario;
}
