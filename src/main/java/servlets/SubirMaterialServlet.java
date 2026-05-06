package servlets;

import Enums.Rol;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import schemas.Usuario;

import java.io.IOException;

@WebServlet(name = "subirMaterialServlet", urlPatterns = "/tutor/subir")
@MultipartConfig(maxFileSize = 25 * 1024 * 1024)
public class SubirMaterialServlet extends HttpServlet {

    private static final String VIEW = "/WEB-INF/jsp/tutor/subir-material.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!esTutor(req, resp)) return;
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!esTutor(req, resp)) return;
        // TODO: implementar lógica de guardado de material
        req.setAttribute("error", "La funcionalidad de subida aún no está implementada.");
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    private boolean esTutor(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("usuarioLogueado") instanceof Usuario u)
                || u.getRol() != Rol.TUTOR) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
