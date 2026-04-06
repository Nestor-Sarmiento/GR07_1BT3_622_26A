package epn.services;

import epn.Enums.Rol;
import epn.repositories.AdminRepository;
import epn.schemas.Admin;
import epn.schemas.Usuario;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class UserService {

    private final AdminRepository adminRepository;
    private final PasswordEncoder passwordEncoder;
    private final PasswordGeneratorService passwordGeneratorService;
    private final EmailService emailService;

    public UserService(AdminRepository adminRepository, PasswordEncoder passwordEncoder, 
                       PasswordGeneratorService passwordGeneratorService, EmailService emailService) {
        this.adminRepository = adminRepository;
        this.passwordEncoder = passwordEncoder;
        this.passwordGeneratorService = passwordGeneratorService;
        this.emailService = emailService;
    }

    public List<Admin> listarAdmins() {
        return adminRepository.findAll();
    }

    public Admin obtenerAdminPorId(String id) {
        return findByIdOrThrow(adminRepository, id, "Admin no encontrado");
    }

    public Admin obtenerAdminPorEmail(String email) {
        return adminRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Admin no encontrado con email: " + email));
    }

    public java.util.Map<String, String> obtenerMisDatos(String email) {
        Admin admin = adminRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Admin no encontrado con email: " + email));
        
        return java.util.Map.of(
                "nombre", admin.getNombre(),
                "apellido", admin.getApellido(),
                "email", admin.getEmail()
        );
    }

    public Admin crearAdmin(Admin admin) {
        if (adminRepository.existsByEmail(admin.getEmail())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "El email " + admin.getEmail() + " ya está en uso.");
        }

        // 1. Generar contraseña temporal segura
        String temporaryPassword = passwordGeneratorService.generateSecurePassword();
        String passwordHasheada = passwordEncoder.encode(temporaryPassword);
        admin.setPassword(passwordHasheada);

        // 2. Marcar que el admin debe cambiar la contraseña en el siguiente login
        admin.setMustChangePassword(true);

        // 3. Asegurar que sea admin (por seguridad)
        admin.setRol(Rol.ADMIN);
        
        // 4. Guardar en base de datos
        Admin adminGuardado = adminRepository.save(admin);

        // 5. Enviar email con credenciales temporales
        String nombreCompleto = admin.getNombre() + " " + admin.getApellido();
        emailService.sendTemporaryPasswordEmail(admin.getEmail(), nombreCompleto, temporaryPassword);

        return adminGuardado;
    }

    public Admin actualizarAdmin(String id, Admin adminActualizado) {
        Admin existente = obtenerAdminPorId(id);
        copyEditableFields(existente, adminActualizado);
        existente.setRol(Rol.ADMIN);
        return adminRepository.save(existente);
    }

    /**
     * Actualiza solo nombre y apellido del administrador autenticado
     * 
     * @param email Email del administrador autenticado
     * @param adminActualizado Objeto con nombre y/o apellido a actualizar
     * @return Admin actualizado
     */
    public Admin actualizarMisDatos(String email, Admin adminActualizado) {
        Admin existente = adminRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Admin no encontrado"));

        // Solo permitir actualizar nombre
        if (adminActualizado.getNombre() != null && !adminActualizado.getNombre().isBlank()) {
            existente.setNombre(adminActualizado.getNombre());
        }

        // Solo permitir actualizar apellido
        if (adminActualizado.getApellido() != null && !adminActualizado.getApellido().isBlank()) {
            existente.setApellido(adminActualizado.getApellido());
        }

        return adminRepository.save(existente);
    }

    @SuppressWarnings("null")
    public void eliminarAdmin(String id) {
        Admin existente = obtenerAdminPorId(id);
        // Borrado lógico: cambiar estado a INACTIVO en lugar de eliminar físicamente
        existente.setEstado(epn.Enums.Estados.INACTIVO);
        adminRepository.save(existente);
    }

    @SuppressWarnings("null")
    private <T extends Usuario> T findByIdOrThrow(MongoRepository<T, String> repository, String id,
            String notFoundMessage) {
        return repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, notFoundMessage));
    }

    private void copyEditableFields(Usuario existing, Usuario updated) {
        existing.setEmail(updated.getEmail());
        existing.setNombre(updated.getNombre());
        existing.setApellido(updated.getApellido());
        
        // Encriptar password si se proporciona
        if (updated.getPassword() != null && !updated.getPassword().isBlank()) {
            String passwordHasheada = passwordEncoder.encode(updated.getPassword());
            existing.setPassword(passwordHasheada);
        }
    }

    /**
     * Cambia la contraseña del usuario y marca que ya no necesita cambiarla
     * 
     * @param email Email del usuario
     * @param newPassword Nueva contraseña
     */
    public void changePassword(String email, String newPassword) {
        // Buscar usuario por email
        Admin admin = adminRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Admin no encontrado con email: " + email));

        // Validar que no esté vacío
        if (newPassword == null || newPassword.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "La nueva contraseña no puede estar vacía");
        }

        // Encriptar y actualizar
        String passwordHasheada = passwordEncoder.encode(newPassword);
        admin.setPassword(passwordHasheada);
        admin.setMustChangePassword(false);  // Ya cambió la contraseña

        adminRepository.save(admin);

        // Enviar notificación por email
        String nombreCompleto = admin.getNombre() + " " + admin.getApellido();
        emailService.sendPasswordChangedEmail(admin.getEmail(), nombreCompleto);
    }
}