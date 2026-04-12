package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * MaterialDetalleServlet
 *
 * GET  /material/detalle?id=X  → muestra detalle-material.jsp
 * POST /material/accion        → procesa Aceptar o Rechazar
 *
 * Parámetros POST:
 *   - id     : Long  (id del material)
 *   - accion : String  ("ACEPTAR" | "RECHAZAR")
 *
 * TODO (back): cuando exista el repositorio de materiales,
 *   1. En doGet:  buscar material por id y hacer request.setAttribute("material", material)
 *   2. En doPost: actualizar estado del material en BD según accion
 */
@WebServlet(name = "materialDetalleServlet", urlPatterns = {"/material/detalle", "/material/accion"})
public class MaterialDetalleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminLogueado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // TODO: cuando exista MaterialRepository, descomentar y usar:
        // String idParam = req.getParameter("id");
        // if (idParam != null) {
        //     Long id = Long.parseLong(idParam);
        //     Material material = materialRepository.findById(id);
        //     req.setAttribute("material", material);
        // }

        req.getRequestDispatcher("/WEB-INF/jsp/admin/detalle-material.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminLogueado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String idParam = req.getParameter("id");
        String accion  = req.getParameter("accion");

        // TODO: cuando exista MaterialRepository, implementar:
        // Long id = Long.parseLong(idParam);
        // if ("ACEPTAR".equals(accion)) {
        //     materialRepository.updateEstado(id, "ACEPTADO");
        //     req.setAttribute("mensaje", "Material aceptado correctamente.");
        // } else if ("RECHAZAR".equals(accion)) {
        //     materialRepository.updateEstado(id, "RECHAZADO");
        //     req.setAttribute("mensaje", "Material rechazado correctamente.");
        // }

        // Por ahora solo redirige de vuelta a materiales con mensaje
        if ("ACEPTAR".equals(accion)) {
            req.getSession().setAttribute("flashMensaje", "Material aceptado correctamente.");
        } else if ("RECHAZAR".equals(accion)) {
            req.getSession().setAttribute("flashMensaje", "Material rechazado correctamente.");
        }

        resp.sendRedirect(req.getContextPath() + "/materiales");
    }
}
