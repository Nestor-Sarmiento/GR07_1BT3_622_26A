package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import schemas.Estudiante;
import schemas.Usuario;
import repositories.JpaUtil;
import jakarta.persistence.EntityManager;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "estudianteDashboardServlet", urlPatterns = "/estudiante/dashboard")
public class EstudianteDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Optional<Usuario> usuarioOpt = ServletUtils.estudianteDesdeSesion(session);
        if (usuarioOpt.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        Usuario usuario = usuarioOpt.get();

        if (usuario.getIdPersona() != null) {
            try (EntityManager em = JpaUtil.createEntityManager()) {
                Estudiante estudiantePerfil = em.find(Estudiante.class, usuario.getIdPersona());
                req.setAttribute("estudiantePerfil", estudiantePerfil);
            }
        }

        req.getRequestDispatcher("/WEB-INF/jsp/estudiante/dashboard-estudiante.jsp").forward(req, resp);
    }
}
