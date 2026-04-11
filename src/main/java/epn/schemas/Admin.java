package epn.schemas;

import epn.Enums.Estados;
import epn.Enums.Rol;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@EqualsAndHashCode(callSuper = true)
@Entity
@DiscriminatorValue("ADMIN")
public class Admin extends Usuario {

	public Admin(Long id_usuario, String email, String nombre, String apellido, String password, Estados estado) {
		super(id_usuario, email, nombre, apellido, Rol.ADMIN, password, estado, false);
		setRolAdmin();
	}

	private void setRolAdmin() {
		this.setRol(Rol.ADMIN);
	}
}
