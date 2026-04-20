package servlets;

import Enums.Rol;
import repositories.UsuarioRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import schemas.Usuario;
import services.EstudianteService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "estudianteServlet", urlPatterns = "/estudiantes")
public class EstudianteServlet extends HttpServlet {
    private final UsuarioRepository usuarioRepository = new UsuarioRepository();
    private final EstudianteService estudianteService = new EstudianteService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("adminLogueado") instanceof Usuario)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Usuario> estudiantes = estudianteService.obtenerTodos(usuarioRepository);
        req.setAttribute("estudiantes", estudiantes);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/estudiantes.jsp").forward(req, resp);
    }
}


