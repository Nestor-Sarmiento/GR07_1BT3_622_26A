package servlets;

import Enums.MateriaFIS;
import Enums.Rol;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import schemas.Usuario;

import java.io.IOException;

@WebServlet(name = "perfilTutorServlet", urlPatterns = "/tutor/perfil")
public class PerfilTutorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("usuarioLogueado") instanceof Usuario tutor)
                || tutor.getRol() != Rol.TUTOR) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.setAttribute("materias", MateriaFIS.values());
        req.getRequestDispatcher("/WEB-INF/jsp/tutor/perfil-tutor.jsp").forward(req, resp);
    }
}
