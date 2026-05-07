package servlets;

import Enums.Rol;
import repositories.MaterialRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import schemas.Material;
import schemas.Usuario;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "detalleMaterialTutorServlet", urlPatterns = "/tutor/material/detalle")
public class DetalleMaterialTutorServlet extends HttpServlet {

    private static final String VIEW = "/WEB-INF/jsp/tutor/detalle-visualizar-material-tutor.jsp";
    private final MaterialRepository materialRepository = new MaterialRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("usuarioLogueado") instanceof Usuario tutor)
                || tutor.getRol() != Rol.TUTOR) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isBlank()) {
            try {
                Long id = Long.parseLong(idStr);
                Optional<Material> materialOpt = materialRepository.findById(id);
                materialOpt.ifPresent(material -> req.setAttribute("material", material));
            } catch (NumberFormatException ignored) {}
        }

        req.getRequestDispatcher(VIEW).forward(req, resp);
    }
}
