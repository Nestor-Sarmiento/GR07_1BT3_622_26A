package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repositories.UsuarioRepository;
import schemas.Usuario;
import services.EstudianteService;

import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "estudianteCrearServlet", urlPatterns = "/estudiante/crear")
public class EstudianteCrearServlet extends HttpServlet {
    private final UsuarioRepository usuarioRepository = new UsuarioRepository();
    private final EstudianteService estudianteService = new EstudianteService();

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

        // Validar nombre y correo usando EstudianteService
        if (!estudianteService.validarNombre(nombre)) {
            req.setAttribute("error", "El nombre es obligatorio y no puede estar vacío.");
            req.getRequestDispatcher("/WEB-INF/jsp/admin/crear-estudiante.jsp").forward(req, resp);
            return;
        }

        if (!estudianteService.validarCorreo(email)) {
            req.setAttribute("error", "El correo electrónico debe ser válido (formato: usuario@dominio.com).");
            req.getRequestDispatcher("/WEB-INF/jsp/admin/crear-estudiante.jsp").forward(req, resp);
            return;
        }

        if (usuarioRepository.existsByEmail(email, null)) {
            req.setAttribute("error", "Ya existe un usuario con ese email.");
            req.getRequestDispatcher("/WEB-INF/jsp/admin/crear-estudiante.jsp").forward(req, resp);
            return;
        }

        String passwordTemporal = generarPasswordTemporal();
        try {
            Usuario estudiante = estudianteService.crearEstudiante(
                    usuarioRepository,
                    nombre,
                    email,
                    passwordTemporal
            );
            
            // Actualizar apellido (EstudianteService no lo maneja)
            estudiante.setApellido(apellido);
            usuarioRepository.save(estudiante);

            session.setAttribute("mensaje", "Cuenta de estudiante creada correctamente. Credenciales temporales: "
                    + email + " / " + passwordTemporal);
            resp.sendRedirect(req.getContextPath() + "/estudiantes");
        } catch (IllegalArgumentException ex) {
            req.setAttribute("error", "Error al crear estudiante: " + ex.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/admin/crear-estudiante.jsp").forward(req, resp);
        }
    }

    private String value(String input) {
        return input == null ? "" : input.trim();
    }

    private String generarPasswordTemporal() {
        return UUID.randomUUID().toString().replace("-", "").substring(0, 10) + "A1";
    }
}

