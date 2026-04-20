package servlets;

import Enums.Rol;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repositories.UsuarioRepository;
import schemas.Usuario;
import services.EstudianteService;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "estudianteEditarServlet", urlPatterns = "/estudiante/editar")
public class EstudianteEditarServlet extends HttpServlet {
    private final UsuarioRepository usuarioRepository = new UsuarioRepository();
    private final EstudianteService estudianteService = new EstudianteService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("adminLogueado") instanceof Usuario)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Long id = parseLong(req.getParameter("id"));
        if (id == null) {
            flash(session, "error", "No se pudo identificar el estudiante a actualizar.");
            resp.sendRedirect(req.getContextPath() + "/estudiantes");
            return;
        }

        Optional<Usuario> usuarioOpt = usuarioRepository.findById(id);
        if (usuarioOpt.isEmpty()) {
            flash(session, "error", "El estudiante seleccionado no existe.");
            resp.sendRedirect(req.getContextPath() + "/estudiantes");
            return;
        }

        Usuario usuario = usuarioOpt.get();
        if (usuario.getRol() != Rol.ESTUDIANTE) {
            flash(session, "error", "Solo se pueden editar estudiantes.");
            resp.sendRedirect(req.getContextPath() + "/estudiantes");
            return;
        }

        String nombre = value(req.getParameter("nombre"));
        String apellido = value(req.getParameter("apellido"));
        String segundoNombre = value(req.getParameter("segundo_nombre"));
        String segundoApellido = value(req.getParameter("segundo_apellido"));
        String email = value(req.getParameter("email"));
        String password = value(req.getParameter("password"));

        // Validar nombre y correo usando EstudianteService
        if (!estudianteService.validarActualizacionDatos(nombre, email)) {
            flash(session, "error", "Nombre y correo electrónico son obligatorios y deben ser válidos.");
            resp.sendRedirect(req.getContextPath() + "/estudiante/detalle?id=" + id);
            return;
        }

        if (usuarioRepository.existsByEmail(email, id)) {
            flash(session, "error", "Ya existe otro usuario con ese correo electrónico.");
            resp.sendRedirect(req.getContextPath() + "/estudiante/detalle?id=" + id);
            return;
        }

        usuario.setNombre(nombre);
        usuario.setApellido(apellido);
        usuario.setSegundoNombre(segundoNombre);
        usuario.setSegundoApellido(segundoApellido);
        usuario.setEmail(email);
        if (!password.isBlank()) {
            usuario.setPassword(password);
            usuario.setMustChangePassword(false);
        }

        usuarioRepository.save(usuario);

        flash(session, "mensaje", "Los datos del estudiante se actualizaron correctamente.");
        resp.sendRedirect(req.getContextPath() + "/estudiante/detalle?id=" + id);
    }

    private void flash(HttpSession session, String key, String value) {
        session.setAttribute(key, value);
    }

    private Long parseLong(String value) {
        try {
            return value == null ? null : Long.parseLong(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private String value(String input) {
        return input == null ? "" : input.trim();
    }
}

