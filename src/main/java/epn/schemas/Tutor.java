package epn.schemas;

import epn.Enums.Estados;
import epn.Enums.Rol;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

@NoArgsConstructor
@Document(collection = "tutores")
public class Tutor extends Usuario {

	public Tutor(String id_usuario, String email, String nombre, String apellido, String password, Estados estado) {
		super(id_usuario, email, nombre, apellido, Rol.TUTOR, password, estado);
		setRolTutor();
	}

	private void setRolTutor() {
		this.setRol(Rol.TUTOR);
	}
}
