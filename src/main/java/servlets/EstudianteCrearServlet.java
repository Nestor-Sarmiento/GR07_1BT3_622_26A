package servlets;

import Enums.Estados;
import Enums.Rol;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repositories.UsuarioRepository;
import schemas.Usuario;

import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "estudianteCrearServlet", urlPatterns = "/estudiante/crear")
public class EstudianteCrearServlet extends HttpServlet {
    private final UsuarioRepository usuarioRepository = new UsuarioRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("adminLogueado") instanceof Usuario)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/jsp/admin/crear-estudiante.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("adminLogueado") instanceof Usuario)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String nombre = value(req.getParameter("nombre"));
        String apellido = value(req.getParameter("apellido"));
        String email = value(req.getParameter("email"));

        if (nombre.isBlank() || email.isBlank()) {
            req.setAttribute("error", "Nombre y email son obligatorios.");
            req.getRequestDispatcher("/WEB-INF/jsp/admin/crear-estudiante.jsp").forward(req, resp);
            return;
        }

        if (usuarioRepository.existsByEmail(email, null)) {
            req.setAttribute("error", "Ya existe un usuario con ese email.");
            req.getRequestDispatcher("/WEB-INF/jsp/admin/crear-estudiante.jsp").forward(req, resp);
            return;
        }

        String passwordTemporal = generarPasswordTemporal();
        Usuario estudiante = Usuario.builder()
                .email(email)
                .nombre(nombre)
                .apellido(apellido)
                .password(passwordTemporal)
                .rol(Rol.ESTUDIANTE)
                .estado(Estados.ACTIVO)
                .mustChangePassword(true)
                .build();

        usuarioRepository.save(estudiante);

        session.setAttribute("mensaje", "Cuenta de estudiante creada correctamente. Credenciales temporales: "
                + email + " / " + passwordTemporal);
        resp.sendRedirect(req.getContextPath() + "/estudiantes");
    }

    private String value(String input) {
        return input == null ? "" : input.trim();
    }

    private String generarPasswordTemporal() {
        return UUID.randomUUID().toString().replace("-", "").substring(0, 10) + "A1";
    }
}

