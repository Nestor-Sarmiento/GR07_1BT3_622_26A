package schemas;

import Enums.Estados;
import Enums.Rol;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.SuperBuilder;

@Data
@AllArgsConstructor
@SuperBuilder
@EqualsAndHashCode(callSuper = true)
@Entity
@DiscriminatorValue("ADMIN")
public class Admin extends Usuario {

	public Admin(Long id_usuario, String email, String nombre, String apellido, String password, Estados estado) {
		super(id_usuario, email, nombre, null, apellido, null, Rol.ADMIN, password, estado, false);
		setRolAdmin();
	}

	private void setRolAdmin() {
		this.setRol(Rol.ADMIN);
	}
}
