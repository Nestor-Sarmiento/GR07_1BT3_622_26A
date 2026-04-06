package epn.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import epn.repositories.AdminRepository;
import epn.utils.JwtUtil;

@Service
public class AuthService {
    @Autowired
    private AdminRepository adminRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private JwtUtil jwtUtil;

    /**
     * Autentica al usuario y retorna un token JWT + información sobre cambio de password obligatorio
     * 
     * @param email Email del usuario
     * @param passwordEnviado Contraseña proporcionada
     * @return AuthResponse con token y flag de mustChangePassword
     */
    public AuthResponse autenticar(String email, String passwordEnviado) {
        return adminRepository.findByEmail(email)
                .filter(admin -> passwordEncoder.matches(passwordEnviado, admin.getPassword()))
                .map(admin -> {
                    String token = jwtUtil.generarToken(admin.getEmail());
                    boolean mustChange = admin.isMustChangePassword();
                    String message = mustChange 
                        ? "Token generado. DEBE cambiar su contraseña antes de continuar." 
                        : "Autenticación exitosa";
                    return new AuthResponse(token, mustChange, message);
                })
                .orElse(null);
    }
}