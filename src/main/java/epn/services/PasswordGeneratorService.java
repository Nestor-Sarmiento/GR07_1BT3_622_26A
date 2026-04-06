package epn.services;

import org.springframework.stereotype.Service;
import java.security.SecureRandom;

@Service
public class PasswordGeneratorService {
    
    private static final String UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String LOWERCASE = "abcdefghijklmnopqrstuvwxyz";
    private static final String DIGITS = "0123456789";
    private static final String SPECIAL = "!@#$%^&*()_+-=[]{}|;:,.<>?";
    private static final String ALL_CHARS = UPPERCASE + LOWERCASE + DIGITS + SPECIAL;
    
    private final SecureRandom secureRandom = new SecureRandom();
    
    /**
     * Genera una contraseña aleatoria segura de 16 caracteres
     * Incluye: mayúsculas, minúsculas, dígitos y caracteres especiales
     * 
     * @return Contraseña generada
     */
    public String generateSecurePassword() {
        StringBuilder password = new StringBuilder(16);
        
        // Garantizar que tenga al menos uno de cada tipo
        password.append(getRandomChar(UPPERCASE));
        password.append(getRandomChar(LOWERCASE));
        password.append(getRandomChar(DIGITS));
        password.append(getRandomChar(SPECIAL));
        
        // Llenar el resto aleatoriamente
        for (int i = 4; i < 16; i++) {
            password.append(getRandomChar(ALL_CHARS));
        }
        
        // Mezclar los caracteres para mayor seguridad
        return shuffle(password.toString());
    }
    
    private char getRandomChar(String chars) {
        return chars.charAt(secureRandom.nextInt(chars.length()));
    }
    
    private String shuffle(String input) {
        char[] chars = input.toCharArray();
        for (int i = chars.length - 1; i > 0; i--) {
            int j = secureRandom.nextInt(i + 1);
            char temp = chars[i];
            chars[i] = chars[j];
            chars[j] = temp;
        }
        return new String(chars);
    }
}
