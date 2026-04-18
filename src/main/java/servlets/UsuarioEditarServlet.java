package servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repositories.UsuarioRepository;
import schemas.Usuario;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "usuarioEditarServlet", urlPatterns = "/usuario/editar")
public class UsuarioEditarServlet extends HttpServlet {
    private final UsuarioRepository usuarioRepository = new UsuarioRepository();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("adminLogueado") instanceof Usuario)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Long id = parseLong(req.getParameter("id"));
        if (id == null) {
            flash(session, "error", "No se pudo identificar el usuario a actualizar.");
            resp.sendRedirect(req.getContextPath() + "/usuarios");
            return;
        }

        Optional<Usuario> usuarioOpt = usuarioRepository.findById(id);
        if (usuarioOpt.isEmpty()) {
            flash(session, "error", "El usuario seleccionado no existe.");
            resp.sendRedirect(req.getContextPath() + "/usuarios");
            return;
        }

        String nombre = value(req.getParameter("nombre"));
        String apellido = value(req.getParameter("apellido"));
        String email = value(req.getParameter("email"));
        String password = value(req.getParameter("password"));

        if (nombre.isBlank() || email.isBlank()) {
            flash(session, "error", "Nombre y correo electrónico son obligatorios.");
            resp.sendRedirect(req.getContextPath() + "/usuario/detalle?id=" + id);
            return;
        }

        if (usuarioRepository.existsByEmail(email, id)) {
            flash(session, "error", "Ya existe otro usuario con ese correo electrónico.");
            resp.sendRedirect(req.getContextPath() + "/usuario/detalle?id=" + id);
            return;
        }

        Usuario usuario = usuarioOpt.get();
        usuario.setNombre(nombre);
        usuario.setApellido(apellido);
        usuario.setEmail(email);
        if (!password.isBlank()) {
            usuario.setPassword(password);
            usuario.setMustChangePassword(false);
        }

        Usuario actualizado = usuarioRepository.save(usuario);

        Object adminLogueado = session.getAttribute("adminLogueado");
        if (adminLogueado instanceof Usuario usuarioLogueado
                && usuarioLogueado.getId_usuario() != null
                && usuarioLogueado.getId_usuario().equals(actualizado.getId_usuario())) {
            session.setAttribute("adminLogueado", actualizado);
        }

        flash(session, "mensaje", "Los datos del usuario se actualizaron correctamente.");
        resp.sendRedirect(req.getContextPath() + "/usuario/detalle?id=" + id);
    }

    private void flash(HttpSession session, String key, String value) {
        session.setAttribute(key, value);
    }

    private Long parseLong(String value) {
        return Optional.ofNullable(value)
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .map(this::tryParseLong)
                .orElse(null);
    }

    private Long tryParseLong(String value) {
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException ex) {
            return null;
        }
    }


    private String value(String input) {
        return input == null ? "" : input.trim();
    }
}


