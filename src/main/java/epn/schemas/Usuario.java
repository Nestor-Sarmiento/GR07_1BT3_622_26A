package epn.schemas;

import epn.Enums.Estados;
import epn.Enums.Rol;
import org.springframework.data.annotation.Id;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;



@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Usuario {
    @Id
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private String id_usuario;

    private String email;
    private String nombre;
    private String apellido;
    private Rol rol;

    @JsonProperty("password")
    private String password;

    private Estados estado;
    
    @Builder.Default
    private boolean mustChangePassword = false;  // Flag para forzar cambio de password en primer login
}
