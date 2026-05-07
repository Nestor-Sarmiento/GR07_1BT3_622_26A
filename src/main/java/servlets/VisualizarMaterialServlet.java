package servlets;

import Enums.EstadoMaterial;
import Enums.Rol;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repositories.MaterialRepository;
import schemas.Material;
import schemas.Usuario;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "visualizarMaterialServlet", urlPatterns = "/tutor/materiales")
public class VisualizarMaterialServlet extends HttpServlet {

    private static final String VIEW = "/WEB-INF/jsp/tutor/visualizar-material.jsp";
    private final MaterialRepository materialRepository = new MaterialRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Usuario tutor = obtenerTutorAutenticado(session);
        if (tutor == null) {
            redirigirLogin(req, resp);
            return;
        }

        // Filtrar materiales por el nombre del usuario logueado
        List<Material> materiales = materialRepository.findByUsuario(tutor.getNombre());
        long[] resumen = calcularResumenMateriales(materiales);
        cargarAtributosVista(req, materiales, resumen);

        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    private Usuario obtenerTutorAutenticado(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object usuarioLogueado = session.getAttribute("usuarioLogueado");
        if (!(usuarioLogueado instanceof Usuario tutor)) {
            return null;
        }
        return tutor.getRol() == Rol.TUTOR ? tutor : null;
    }

    private void redirigirLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/login");
    }

    private long[] calcularResumenMateriales(List<Material> materiales) {
        long total = (materiales != null) ? materiales.size() : 0;
        long aprobados = (materiales != null)
                ? materiales.stream().filter(m -> m.getEstado() == EstadoMaterial.APROBADO).count()
                : 0;
        long enRevision = (materiales != null)
                ? materiales.stream().filter(m -> m.getEstado() == EstadoMaterial.PENDIENTE).count()
                : 0;
        return new long[]{total, aprobados, enRevision};
    }

    private void cargarAtributosVista(HttpServletRequest req, List<Material> materiales, long[] resumen) {
        req.setAttribute("materiales", materiales);
        req.setAttribute("totalMateriales", resumen[0]);
        req.setAttribute("materialesAprobados", resumen[1]);
        req.setAttribute("materialesEnRevision", resumen[2]);
    }
}
