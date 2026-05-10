package servlets;

import Enums.Rol;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import schemas.Usuario;

import java.io.IOException;

@WebServlet(name = "verPerfilTutorServlet", urlPatterns = "/estudiante/tutor/perfil")
public class VerPerfilTutorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("usuarioLogueado") instanceof Usuario estudiante)
                || estudiante.getRol() != Rol.ESTUDIANTE) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/jsp/estudiante/perfil-tutor-estudiante.jsp").forward(req, resp);
    }
}
