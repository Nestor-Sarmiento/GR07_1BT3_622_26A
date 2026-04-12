package servlets;

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

@WebServlet(name = "perfilServlet", urlPatterns = "/perfil")
public class PerfilServlet extends HttpServlet {
    private final AdminRepository adminRepository = new AdminRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminLogueado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario admin = (Usuario) session.getAttribute("adminLogueado");
        req.setAttribute("admin", admin);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/perfil.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminLogueado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario admin = (Usuario) session.getAttribute("adminLogueado");
        String action = req.getParameter("action");

        if ("datos".equals(action)) {
            // Update personal data
            String primerNombre = req.getParameter("primer_nombre");
            String segundoNombre = req.getParameter("segundo_nombre");
            String primerApellido = req.getParameter("primer_apellido");
            String segundoApellido = req.getParameter("segundo_apellido");

            if (primerNombre != null && !primerNombre.trim().isEmpty() &&
                primerApellido != null && !primerApellido.trim().isEmpty()) {

                admin.setNombre(primerNombre.trim());
                admin.setSegundoNombre(segundoNombre != null ? segundoNombre.trim() : null);
                admin.setApellido(primerApellido.trim());
                admin.setSegundoApellido(segundoApellido != null ? segundoApellido.trim() : null);

                adminRepository.save((Admin) admin);
                session.setAttribute("adminLogueado", admin);

                req.setAttribute("mensaje", "Datos personales actualizados correctamente.");
            } else {
                req.setAttribute("error", "Los campos de primer nombre y primer apellido son obligatorios.");
            }
        } else if ("password".equals(action)) {
            // Update password
            String passwordActual = req.getParameter("passwordActual");
            String passwordNuevo = req.getParameter("passwordNuevo");
            String passwordConfirm = req.getParameter("passwordConfirm");

            if (passwordActual != null && !passwordActual.isEmpty()) {
                if (!passwordActual.equals(admin.getPassword())) {
                    req.setAttribute("error", "La contraseña actual es incorrecta.");
                } else if (passwordNuevo != null && !passwordNuevo.isEmpty()) {
                    if (!passwordNuevo.equals(passwordConfirm)) {
                        req.setAttribute("error", "Las nuevas contraseñas no coinciden.");
                    } else if (passwordNuevo.length() < 6) {
                        req.setAttribute("error", "La nueva contraseña debe tener al menos 6 caracteres.");
                    } else {
                        admin.setPassword(passwordNuevo);
                        adminRepository.save((Admin) admin);
                        session.setAttribute("adminLogueado", admin);
                        req.setAttribute("mensaje", "Contraseña actualizada correctamente.");
                    }
                } else {
                    req.setAttribute("error", "Debes ingresar una nueva contraseña.");
                }
            } else {
                req.setAttribute("error", "Debes ingresar tu contraseña actual.");
            }
        }

        req.getRequestDispatcher("/WEB-INF/jsp/admin/perfil.jsp").forward(req, resp);
    }
}
