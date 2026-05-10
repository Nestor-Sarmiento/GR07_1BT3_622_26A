package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repositories.AdminRepository;
import schemas.Usuario;
import schemas.Admin;
import repositories.JpaUtil;
import jakarta.persistence.EntityManager;

import java.io.IOException;

import servlets.validators.PasswordValidator;

@WebServlet(name = "perfilServlet", urlPatterns = "/perfil")
public class PerfilServlet extends HttpServlet {
    private final AdminRepository adminRepository = new AdminRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogueado");
        Usuario adminLogueado = (Usuario) session.getAttribute("adminLogueado");

        if (adminLogueado != null) {
            if (adminLogueado.getIdPersona() != null) {
                try (EntityManager em = JpaUtil.createEntityManager()) {
                    Admin adminPerfil = em.find(Admin.class, adminLogueado.getIdPersona());
                    req.setAttribute("admin", adminPerfil);
                }
            }
            req.getRequestDispatcher("/WEB-INF/jsp/admin/perfil.jsp").forward(req, resp);
        } else if (usuarioLogueado != null && usuarioLogueado.getRol() == Enums.Rol.ESTUDIANTE) {
            if (usuarioLogueado.getIdPersona() != null) {
                try (EntityManager em = JpaUtil.createEntityManager()) {
                    schemas.Estudiante estudiantePerfil = em.find(schemas.Estudiante.class, usuarioLogueado.getIdPersona());
                    req.setAttribute("estudiantePerfil", estudiantePerfil);
                }
            }
            req.getRequestDispatcher("/WEB-INF/jsp/estudiante/perfil-estudiante.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminLogueado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario adminUser = (Usuario) session.getAttribute("adminLogueado");
        Admin admin = null;
        if (adminUser.getIdPersona() != null) {
            try (EntityManager em = JpaUtil.createEntityManager()) {
                admin = em.find(Admin.class, adminUser.getIdPersona());
            }
        }

        String action = req.getParameter("action");

        if ("datos".equals(action)) {
            procesarActualizacionDatos(req, admin);
        } else if ("password".equals(action)) {
            procesarCambioPassword(req, admin);
        }

        req.setAttribute("admin", admin);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/perfil.jsp").forward(req, resp);
    }

    private void procesarActualizacionDatos(HttpServletRequest req, Admin admin) {
        String primerNombre = req.getParameter("primer_nombre");
        String segundoNombre = req.getParameter("segundo_nombre");
        String primerApellido = req.getParameter("primer_apellido");
        String segundoApellido = req.getParameter("segundo_apellido");

        if (isBlank(primerNombre) || isBlank(primerApellido)) {
            req.setAttribute("error", "Los campos de primer nombre y primer apellido son obligatorios.");
            return;
        }

        admin.setNombre(primerNombre.trim());
        admin.setSegundoNombre(segundoNombre != null ? segundoNombre.trim() : null);
        admin.setApellido(primerApellido.trim());
        admin.setSegundoApellido(segundoApellido != null ? segundoApellido.trim() : null);

        // Guardar cambios en la tabla de administradores
        adminRepository.save(admin);

        // Si el admin logueado es el mismo que se está editando, actualizar sesión
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.setAttribute("adminLogueado_info", admin);
        }

        req.setAttribute("mensaje", "Datos personales actualizados correctamente.");
    }

    private void procesarCambioPassword(HttpServletRequest req, Admin admin) {
        String passwordActual = req.getParameter("passwordActual");
        String passwordNuevo = req.getParameter("passwordNuevo");
        String passwordConfirm = req.getParameter("passwordConfirm");

        HttpSession session = req.getSession(false);
        Usuario userSession = (Usuario) session.getAttribute("adminLogueado");

        PasswordValidator validator = new PasswordValidator();
        String error = validator.validate(passwordActual, passwordNuevo, passwordConfirm, userSession.getPassword());

        if (error != null) {
            req.setAttribute("error", error);
            return;
        }

        userSession.setPassword(passwordNuevo);
        repositories.UsuarioRepository userRepo = new repositories.UsuarioRepository();
        userRepo.save(userSession);

        session.setAttribute("adminLogueado", userSession);
        req.setAttribute("mensaje", "Contraseña actualizada correctamente.");
    }


    private void guardarAdminEnSesion(HttpServletRequest req, Admin admin) {
        adminRepository.save(admin);
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.setAttribute("adminLogueado_info", admin);
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
