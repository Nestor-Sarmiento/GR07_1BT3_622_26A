package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repositories.AdminRepository;
import schemas.Admin;
import servlets.validators.PasswordValidator;

import java.io.IOException;

@WebServlet(name = "perfilServlet", urlPatterns = "/perfil")
public class PerfilServlet extends HttpServlet {
    private final AdminRepository adminRepository = new AdminRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Admin admin = obtenerAdminAutenticado(req, resp);
        if (admin == null) {
            return;
        }

        req.setAttribute("admin", admin);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/perfil.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Admin admin = obtenerAdminAutenticado(req, resp);
        if (admin == null) {
            return;
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

    private Admin obtenerAdminAutenticado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminLogueado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return (Admin) session.getAttribute("adminLogueado");
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

        guardarAdminEnSesion(req, admin);
        req.setAttribute("mensaje", "Datos personales actualizados correctamente.");
    }

    private void procesarCambioPassword(HttpServletRequest req, Admin admin) {
        String passwordActual = req.getParameter("passwordActual");
        String passwordNuevo = req.getParameter("passwordNuevo");
        String passwordConfirm = req.getParameter("passwordConfirm");

        PasswordValidator validator = new PasswordValidator();
        String error = validator.validate(passwordActual, passwordNuevo, passwordConfirm, admin.getPassword());

        if (error != null) {
            req.setAttribute("error", error);
            return;
        }

        admin.setPassword(passwordNuevo);
        guardarAdminEnSesion(req, admin);
        req.setAttribute("mensaje", "Contraseña actualizada correctamente.");
    }


    private void guardarAdminEnSesion(HttpServletRequest req, Admin admin) {
        adminRepository.save(admin);
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.setAttribute("adminLogueado", admin);
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
