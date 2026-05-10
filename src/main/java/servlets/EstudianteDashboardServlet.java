package servlets;

import Enums.Rol;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import schemas.Usuario;
import schemas.Estudiante;
import repositories.JpaUtil;
import jakarta.persistence.EntityManager;

import java.io.IOException;

@WebServlet(name = "estudianteDashboardServlet", urlPatterns = "/estudiante/dashboard")
public class EstudianteDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("usuarioLogueado") instanceof Usuario usuario)
                || usuario.getRol() != Rol.ESTUDIANTE) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (usuario.getIdPersona() != null) {
            try (EntityManager em = JpaUtil.createEntityManager()) {
                Estudiante estudiantePerfil = em.find(Estudiante.class, usuario.getIdPersona());
                req.setAttribute("estudiantePerfil", estudiantePerfil);
            }
        }

        req.getRequestDispatcher("/WEB-INF/jsp/estudiante/dashboard-estudiante.jsp").forward(req, resp);
    }
}
