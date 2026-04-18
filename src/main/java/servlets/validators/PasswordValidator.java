package servlets.validators;

public class PasswordValidator {

    public static final int MIN_PASSWORD_LENGTH = 6;

    public String validate(String passwordActual, String passwordNuevo, String passwordConfirm, String adminPassword) {
        if (isBlank(passwordActual)) {
            return "Debes ingresar tu contraseña actual.";
        }

        if (!passwordActual.equals(adminPassword)) {
            return "La contraseña actual es incorrecta.";
        }

        if (isBlank(passwordNuevo)) {
            return "Debes ingresar una nueva contraseña.";
        }

        if (!passwordNuevo.equals(passwordConfirm)) {
            return "Las nuevas contraseñas no coinciden.";
        }

        if (passwordNuevo.length() < MIN_PASSWORD_LENGTH) {
            return "La nueva contraseña debe tener al menos 6 caracteres.";
        }

        return null; // válido
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
