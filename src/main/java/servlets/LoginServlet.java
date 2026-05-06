package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repositories.AdminRepository;
import schemas.Usuario;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "loginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {
    private final AdminRepository adminRepository = new AdminRepository();
    private final repositories.UsuarioRepository usuarioRepository = new repositories.UsuarioRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = value(req.getParameter("email")).toLowerCase();
        String password = value(req.getParameter("password"));

        if (email.isBlank() || password.isBlank()) {
            req.setAttribute("error", "Debes ingresar email y contraseña.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // Primero intentamos buscarlo como Administrador (para el dashboard de administración)
        Optional<Usuario> adminOpt = adminRepository.findByEmail(email);

        if (adminOpt.isPresent()) {
            Usuario admin = adminOpt.get();
            if (password.equals(admin.getPassword())) {
                HttpSession session = req.getSession(true);
                session.setAttribute("adminLogueado", admin);
                session.setMaxInactiveInterval(30 * 60);
                resp.sendRedirect(req.getContextPath() + "/dashboardAdmin");
                return;
            }
        }

        // Si no es admin o la clave falló como admin, buscamos en la tabla general de usuarios
        // Nota: findByEmail en AdminRepository solo busca usuarios con Rol.ADMIN
        // Necesitamos un método en UsuarioRepository para buscar por email general
        Optional<Usuario> usuarioOpt = findGeneralUserByEmail(email);

        if (usuarioOpt.isPresent() && password.equals(usuarioOpt.get().getPassword())) {
            Usuario usuario = usuarioOpt.get();
            HttpSession session = req.getSession(true);
            
            // Si el usuario es ADMIN por rol, tratamos como admin logueado
            if (usuario.getRol() == Enums.Rol.ADMIN) {
                session.setAttribute("adminLogueado", usuario);
                session.setMaxInactiveInterval(30 * 60);
                resp.sendRedirect(req.getContextPath() + "/dashboardAdmin");
                return;
            }
            
            // De lo contrario es un usuario normal (TUTOR o ESTUDIANTE)
            session.setAttribute("usuarioLogueado", usuario);
            session.setMaxInactiveInterval(30 * 60);
            
            // Por ahora redirigimos al index.jsp ya que sus dashboards no están implementados
            resp.sendRedirect(req.getContextPath() + "/index.jsp"); 
            return;
        }

        req.setAttribute("error", "Credenciales incorrectas.");
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    private Optional<Usuario> findGeneralUserByEmail(String email) {
        try (jakarta.persistence.EntityManager em = repositories.JpaUtil.createEntityManager()) {
            java.util.List<Usuario> result = em.createQuery(
                    "SELECT u FROM Usuario u WHERE LOWER(TRIM(u.email)) = LOWER(TRIM(:email))", Usuario.class)
                    .setParameter("email", email)
                    .setMaxResults(1)
                    .getResultList();
            return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
        }
    }

    private String value(String input) {
        return input == null ? "" : input.trim();
    }
}
