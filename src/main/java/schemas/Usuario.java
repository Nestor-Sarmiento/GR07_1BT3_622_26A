package schemas;

import Enums.Rol;
import Enums.RolAttributeConverter;
import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PostLoad;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "usuarios")
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_usuario")
    private Long id_usuario;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Convert(converter = RolAttributeConverter.class)
    @Column(nullable = false)
    private Rol rol;

    /**
     * Columna requerida en esquemas PostgreSQL existentes; debe coincidir con {@link #rol}.
     */
    @Convert(converter = RolAttributeConverter.class)
    @Column(name = "tipo_usuario", nullable = false)
    private Rol tipoUsuario;

    @Column(name = "id_persona")
    private Long idPersona;

    @Builder.Default
    @Column(name = "mustchangepassword", nullable = false)
    private boolean mustChangePassword = false;

    @PrePersist
    @PreUpdate
    private void sincronizarTipoUsuario() {
        if (rol != null) {
            this.tipoUsuario = rol;
        }
    }

    @PostLoad
    private void asegurarRolDesdeTipoUsuario() {
        if (tipoUsuario != null && rol == null) {
            this.rol = tipoUsuario;
        }
    }
}
