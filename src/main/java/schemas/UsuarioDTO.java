package schemas;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioDTO {
    private Long id_usuario;
    private String email;
    private String rol;
    private String nombre;
    private String apellido;
    private Long idPersona;
}

