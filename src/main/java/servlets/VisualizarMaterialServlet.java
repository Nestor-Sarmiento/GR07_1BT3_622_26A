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

@WebServlet(name = "visualizarMaterialServlet", urlPatterns = "/tutor/materiales")
public class VisualizarMaterialServlet extends HttpServlet {

    private static final String VIEW = "/WEB-INF/jsp/tutor/visualizar-material.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("usuarioLogueado") instanceof Usuario tutor)
                || tutor.getRol() != Rol.TUTOR) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }
}
