package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import schemas.Usuario;
import schemas.Admin;
import repositories.JpaUtil;
import jakarta.persistence.EntityManager;

import java.io.IOException;

@WebServlet(name = "dashboardAdminServlet", urlPatterns = "/dashboardAdmin")
public class DashboardAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminLogueado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Usuario usuarioLogueado = (Usuario) session.getAttribute("adminLogueado");
        if (usuarioLogueado.getIdPersona() != null) {
            try (EntityManager em = JpaUtil.createEntityManager()) {
                Admin adminPerfil = em.find(Admin.class, usuarioLogueado.getIdPersona());
                req.setAttribute("adminPerfil", adminPerfil);
            }
        }

        req.getRequestDispatcher("/WEB-INF/jsp/admin/dashboardAdmin.jsp").forward(req, resp);
    }
}
