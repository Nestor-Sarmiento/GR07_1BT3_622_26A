package servlets;

import Enums.Estados;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repositories.AdminRepository;
import schemas.Admin;
import schemas.Usuario;

import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "usuarioCrearServlet", urlPatterns = "/usuario/crear")
public class UsuarioCrearServlet extends HttpServlet {
    private final AdminRepository adminRepository = new AdminRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("adminLogueado") instanceof Usuario)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/jsp/admin/crear-admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("adminLogueado") instanceof Usuario)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String nombre = ServletUtils.value(req.getParameter("nombre"));
        String apellido = ServletUtils.value(req.getParameter("apellido"));
        String email = ServletUtils.value(req.getParameter("email"));

        if (nombre.isBlank() || email.isBlank()) {
            req.setAttribute("error", "Nombre y email son obligatorios.");
            req.getRequestDispatcher("/WEB-INF/jsp/admin/crear-admin.jsp").forward(req, resp);
            return;
        }

        if (adminRepository.existsByEmail(email)) {
            req.setAttribute("error", "Ya existe un usuario con ese email.");
            req.getRequestDispatcher("/WEB-INF/jsp/admin/crear-admin.jsp").forward(req, resp);
            return;
        }

        String passwordTemporal = generarPasswordTemporal();
        Admin admin = new Admin(null, email, nombre, apellido, passwordTemporal, Estados.ACTIVO);
        admin.setMustChangePassword(true);
        adminRepository.save(admin);

        req.setAttribute("mensaje", "Cuenta creada correctamente. Credenciales temporales: "
                + email + " / " + passwordTemporal);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/crear-admin.jsp").forward(req, resp);
    }

    private String value(String input) {
        return input == null ? "" : input.trim();
    }

    private String generarPasswordTemporal() {
        return UUID.randomUUID().toString().replace("-", "").substring(0, 10) + "A1";
    }
}



