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
            ServletUtils.flash(session, "error", "No se pudo identificar el estudiante a actualizar.");
            resp.sendRedirect(req.getContextPath() + "/estudiantes");
            return;
        }

        Optional<Usuario> usuarioOpt = usuarioRepository.findById(id);
        if (usuarioOpt.isEmpty()) {
            ServletUtils.flash(session, "error", "El estudiante seleccionado no existe.");
            resp.sendRedirect(req.getContextPath() + "/estudiantes");
            return;
        }

        Usuario usuario = usuarioOpt.get();
        if (usuario.getRol() != Rol.ESTUDIANTE) {
            ServletUtils.flash(session, "error", "Solo se pueden editar estudiantes.");
            resp.sendRedirect(req.getContextPath() + "/estudiantes");
            return;
        }

        String nombre = ServletUtils.value(req.getParameter("nombre"));
        String apellido = ServletUtils.value(req.getParameter("apellido"));
        String segundoNombre = ServletUtils.value(req.getParameter("segundo_nombre"));
        String segundoApellido = ServletUtils.value(req.getParameter("segundo_apellido"));
        String email = ServletUtils.value(req.getParameter("email"));
        String password = ServletUtils.value(req.getParameter("password"));

        // Validar nombre y correo usando EstudianteService
        if (!estudianteService.validarActualizacionDatos(nombre, email)) {
            ServletUtils.flash(session, "error", "Nombre y correo electrónico son obligatorios y deben ser válidos.");
            resp.sendRedirect(req.getContextPath() + "/estudiante/detalle?id=" + id);
            return;
        }

        if (usuarioRepository.existsByEmail(email, id)) {
            ServletUtils.flash(session, "error", "Ya existe otro usuario con ese correo electrónico.");
            resp.sendRedirect(req.getContextPath() + "/estudiante/detalle?id=" + id);
            return;
        }

        usuario.setEmail(email);
        if (!password.isBlank()) {
            usuario.setPassword(password);
        }

        jakarta.persistence.EntityManager em = repositories.JpaUtil.createEntityManager();
        jakarta.persistence.EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            usuarioRepository.save(usuario);

            if (usuario.getIdPersona() != null) {
                schemas.Estudiante est = em.find(schemas.Estudiante.class, usuario.getIdPersona());
                if (est != null) {
                    est.setNombre(nombre);
                    est.setApellido(apellido);
                    est.setSegundoNombre(segundoNombre);
                    est.setSegundoApellido(segundoApellido);
                    em.merge(est);
                }
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            ServletUtils.flash(session, "error", "Error al actualizar datos: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/estudiante/detalle?id=" + id);
            return;
        } finally {
            em.close();
        }

        ServletUtils.flash(session, "mensaje", "Los datos del estudiante se actualizaron correctamente.");
        resp.sendRedirect(req.getContextPath() + "/estudiante/detalle?id=" + id);
    }

    private Long parseLong(String value) {
        try {
            return value == null ? null : Long.parseLong(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
