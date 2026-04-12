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

        Optional<Usuario> adminOpt = adminRepository.findByEmail(email);
        if (adminOpt.isEmpty() || !password.equals(adminOpt.get().getPassword())) {
            req.setAttribute("error", "Credenciales incorrectas.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("adminLogueado", adminOpt.get());
        session.setMaxInactiveInterval(30 * 60);

        resp.sendRedirect(req.getContextPath() + "/usuarios");
    }

    private String value(String input) {
        return input == null ? "" : input.trim();
    }
}

