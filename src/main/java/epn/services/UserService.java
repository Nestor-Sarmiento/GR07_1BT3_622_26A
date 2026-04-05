package epn.services;

import epn.Enums.Rol;
import epn.repositories.AdminRepository;
import epn.repositories.EstudianteRepository;
import epn.repositories.TutorRepository;
import epn.schemas.Admin;
import epn.schemas.Usuario;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class UserService {

    private final AdminRepository adminRepository;

    public UserService(
            AdminRepository adminRepository,
            EstudianteRepository estudianteRepository,
            TutorRepository tutorRepository
    ) {
        this.adminRepository = adminRepository;
    }

    public List<Admin> listarAdmins() {
        return adminRepository.findAll();
    }

    public Admin obtenerAdminPorId(String id) {
        return findByIdOrThrow(adminRepository, id, "Admin no encontrado");
    }

    public Admin crearAdmin(Admin admin) {
        admin.setRol(Rol.ADMIN);
        return adminRepository.save(admin);
    }

    public Admin actualizarAdmin(String id, Admin adminActualizado) {
        Admin existente = obtenerAdminPorId(id);
        copyEditableFields(existente, adminActualizado);
        existente.setRol(Rol.ADMIN);
        return adminRepository.save(existente);
    }

    public void eliminarAdmin(String id) {
        Admin existente = obtenerAdminPorId(id);
        adminRepository.delete(existente);
    }

    private <T extends Usuario> T findByIdOrThrow(MongoRepository<T, String> repository, String id, String notFoundMessage) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, notFoundMessage));
    }

    private void copyEditableFields(Usuario existing, Usuario updated) {
        existing.setEmail(updated.getEmail());
        existing.setNombre(updated.getNombre());
        existing.setApellido(updated.getApellido());
        existing.setPassword(updated.getPassword());
    }
}