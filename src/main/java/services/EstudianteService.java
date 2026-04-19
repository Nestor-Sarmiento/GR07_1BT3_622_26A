package services;

import Enums.EstadoMaterial;
import Enums.Estados;
import Enums.Rol;
import repositories.UsuarioRepository;
import schemas.Material;
import schemas.Usuario;

public class EstudianteService {

    public boolean validarNombre(String nombre) {
        return nombre != null && !nombre.trim().isEmpty();
    }

    public boolean validarCorreo(String correo) {
        return correo != null && correo.contains("@") && correo.contains(".");
    }

    public boolean puedeSolicitarTutoria(boolean tutorDisponible) {
        return tutorDisponible;
    }

    public boolean puedeBloquearEstudiante(Long id) {
        return id != null && id > 0;
    }

    public boolean puedeBloquearEstudiante(Estados estado) {
        return estado == Estados.ACTIVO;
    }

    public boolean puedeDescargarArchivo(Material material) {
        return material != null && material.getEstado() == EstadoMaterial.APROBADO;
    }

    public boolean validarActualizacionDatos(String nombre, String correo) {
        return validarNombre(nombre) && validarCorreo(correo);
    }

    public Usuario crearEstudiante(UsuarioRepository repo, String nombre, String correo, String password) {
        if (!validarNombre(nombre) || !validarCorreo(correo)) {
            throw new IllegalArgumentException("Datos del estudiante inválidos");
        }
        Usuario estudiante = Usuario.builder()
                .nombre(nombre)
                .email(correo)
                .password(password)
                .rol(Rol.ESTUDIANTE)
                .estado(Estados.POR_VERIFICAR)
                .mustChangePassword(true)
                .build();
        return repo.save(estudiante);
    }
}