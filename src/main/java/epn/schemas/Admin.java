package epn.schemas;

import epn.Enums.Estados;
import epn.Enums.Rol;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@Document(collection = "admins")
public class Admin extends Usuario {

	public Admin(String id_usuario, String email, String nombre, String apellido, String password, Estados estado) {
		super(id_usuario, email, nombre, apellido, Rol.ADMIN, password, estado, false);
		setRolAdmin();
	}

	private void setRolAdmin() {
		this.setRol(Rol.ADMIN);
	}
}
