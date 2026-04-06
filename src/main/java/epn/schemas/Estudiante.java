package epn.schemas;

import epn.Enums.Estados;
import epn.Enums.Rol;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

@NoArgsConstructor
@Document(collection = "estudiantes")
public class Estudiante extends Usuario {

    public Estudiante(String id_usuario, String email, String nombre, String apellido, String password, Estados estado) {
        super(id_usuario, email, nombre, apellido, Rol.ESTUDIANTE, password, estado, false);
        setRolEstudiante();
    }

    private void setRolEstudiante(){
        this.setRol(Rol.ESTUDIANTE);
    }

}
