package servlets;

import repositories.MaterialRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "materialServlet", urlPatterns = "/materiales")
public class MaterialServlet extends HttpServlet {
    private final MaterialRepository materialRepository = new MaterialRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminLogueado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        consumeFlash(session, req);
        req.setAttribute("materiales", materialRepository.findAll());

        req.getRequestDispatcher("/WEB-INF/jsp/admin/materiales.jsp").forward(req, resp);
    }

    private void consumeFlash(HttpSession session, HttpServletRequest req) {
        Object mensaje = session.getAttribute("flashMensaje");
        if (mensaje != null) {
            req.setAttribute("mensaje", mensaje);
            session.removeAttribute("flashMensaje");
        }

        Object error = session.getAttribute("flashError");
        if (error != null) {
            req.setAttribute("error", error);
            session.removeAttribute("flashError");
        }
    }
}
