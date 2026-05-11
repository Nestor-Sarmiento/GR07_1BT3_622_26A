package servlets;

import Enums.Rol;
import jakarta.servlet.http.HttpSession;
import schemas.Usuario;

import java.util.Optional;

public class ServletUtils {

    public static String value(String input) {
        return input == null ? "" : input.trim();
    }

    public static void flash(HttpSession session, String key, String value) {
        session.setAttribute(key, value);
    }

    /**
     * Usuario en sesión con rol {@link Rol#ESTUDIANTE}, o vacío si no aplica.
     */
    public static Optional<Usuario> estudianteDesdeSesion(HttpSession session) {
        if (session == null) {
            return Optional.empty();
        }
        Object attr = session.getAttribute("usuarioLogueado");
        if (!(attr instanceof Usuario usuario)) {
            return Optional.empty();
        }
        if (usuario.getRol() != Rol.ESTUDIANTE) {
            return Optional.empty();
        }
        return Optional.of(usuario);
    }
}
