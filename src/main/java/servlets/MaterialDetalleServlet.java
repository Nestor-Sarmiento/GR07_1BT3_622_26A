package servlets;

import Enums.EstadoMaterial;
import repositories.MaterialRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import schemas.Material;

import java.io.IOException;
import java.util.Optional;

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
    private final MaterialRepository materialRepository = new MaterialRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminLogueado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Long id = parseLong(req.getParameter("id"));
        if (id == null) {
            flash(session, "flashError", "No se pudo identificar el material.");
            resp.sendRedirect(req.getContextPath() + "/materiales");
            return;
        }

        Optional<Material> materialOpt = materialRepository.findById(id);
        if (materialOpt.isEmpty()) {
            flash(session, "flashError", "El material seleccionado no existe.");
            resp.sendRedirect(req.getContextPath() + "/materiales");
            return;
        }

        req.setAttribute("material", materialOpt.get());

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

        String accion  = req.getParameter("accion");

        Long id = parseLong(req.getParameter("id"));
        if (id == null) {
            flash(session, "flashError", "No se pudo identificar el material a actualizar.");
            resp.sendRedirect(req.getContextPath() + "/materiales");
            return;
        }

        EstadoMaterial nuevoEstado;
        String mensaje;
        if ("ACEPTAR".equals(accion)) {
            nuevoEstado = EstadoMaterial.APROBADO;
            mensaje = "Material aprobado correctamente.";
        } else if ("RECHAZAR".equals(accion)) {
            nuevoEstado = EstadoMaterial.RECHAZADO;
            mensaje = "Material rechazado correctamente.";
        } else {
            flash(session, "flashError", "Acción no válida para el material.");
            resp.sendRedirect(req.getContextPath() + "/materiales");
            return;
        }

        boolean actualizado = materialRepository.updateEstado(id, nuevoEstado);
        if (!actualizado) {
            flash(session, "flashError", "No se encontró el material para actualizar.");
            resp.sendRedirect(req.getContextPath() + "/materiales");
            return;
        }

        flash(session, "flashMensaje", mensaje);

        resp.sendRedirect(req.getContextPath() + "/materiales");
    }

    private void flash(HttpSession session, String key, String value) {
        session.setAttribute(key, value);
    }

    private Long parseLong(String value) {
        try {
            return value == null ? null : Long.parseLong(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
