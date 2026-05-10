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
            ServletUtils.flash(session, "error", "No se pudo identificar el usuario a actualizar.");
            resp.sendRedirect(req.getContextPath() + "/usuarios");
            return;
        }

        Optional<Usuario> usuarioOpt = usuarioRepository.findById(id);
        if (usuarioOpt.isEmpty()) {
            ServletUtils.flash(session, "error", "El usuario seleccionado no existe.");
            resp.sendRedirect(req.getContextPath() + "/usuarios");
            return;
        }

        String nombre = ServletUtils.value(req.getParameter("nombre"));
        String apellido = ServletUtils.value(req.getParameter("apellido"));
        String email = ServletUtils.value(req.getParameter("email"));
        String password = ServletUtils.value(req.getParameter("password"));

        if (nombre.isBlank() || email.isBlank()) {
            ServletUtils.flash(session, "error", "Nombre y correo electrónico son obligatorios.");
            resp.sendRedirect(req.getContextPath() + "/usuario/detalle?id=" + id);
            return;
        }

        if (usuarioRepository.existsByEmail(email, id)) {
            ServletUtils.flash(session, "error", "Ya existe otro usuario con ese correo electrónico.");
            resp.sendRedirect(req.getContextPath() + "/usuario/detalle?id=" + id);
            return;
        }

        Usuario usuario = usuarioOpt.get();
        usuario.setEmail(email);
        if (!password.isBlank()) {
            usuario.setPassword(password);
            // Si es un admin cambiando password, ya no debe estar marcado
            // pero esto depende de la lógica de negocio.
        }

        jakarta.persistence.EntityManager em = repositories.JpaUtil.createEntityManager();
        jakarta.persistence.EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            usuarioRepository.save(usuario);

            if (usuario.getIdPersona() != null) {
                // Como es una edición general de usuario, intentamos actualizar el perfil
                // Dependiendo del rol, buscamos en la tabla correcta
                if (usuario.getRol() == Enums.Rol.ADMIN) {
                    schemas.Admin admin = em.find(schemas.Admin.class, usuario.getIdPersona());
                    if (admin != null) {
                        admin.setNombre(nombre);
                        admin.setApellido(apellido);
                        em.merge(admin);
                    }
                } else if (usuario.getRol() == Enums.Rol.ESTUDIANTE) {
                    schemas.Estudiante est = em.find(schemas.Estudiante.class, usuario.getIdPersona());
                    if (est != null) {
                        est.setNombre(nombre);
                        est.setApellido(apellido);
                        em.merge(est);
                    }
                } else if (usuario.getRol() == Enums.Rol.TUTOR) {
                    schemas.Tutor tut = em.find(schemas.Tutor.class, usuario.getIdPersona());
                    if (tut != null) {
                        tut.setNombre(nombre);
                        tut.setApellido(apellido);
                        em.merge(tut);
                    }
                }
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            ServletUtils.flash(session, "error", "Error al guardar cambios: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/usuario/detalle?id=" + id);
            return;
        } finally {
            em.close();
        }

        Object adminLogueado = session.getAttribute("adminLogueado");
        if (adminLogueado instanceof Usuario usuarioLogueado
                && usuarioLogueado.getId_usuario() != null
                && usuarioLogueado.getId_usuario().equals(usuario.getId_usuario())) {
            session.setAttribute("adminLogueado", usuario);
        }

        ServletUtils.flash(session, "mensaje", "Los datos del usuario se actualizaron correctamente.");
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


