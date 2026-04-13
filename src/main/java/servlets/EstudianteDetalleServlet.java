package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repositories.UsuarioRepository;
import schemas.Usuario;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "estudianteDetalleServlet", urlPatterns = "/estudiante/detalle")
public class EstudianteDetalleServlet extends HttpServlet {
    private final UsuarioRepository usuarioRepository = new UsuarioRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("adminLogueado") instanceof Usuario)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Object flashMensaje = session.getAttribute("mensaje");
        if (flashMensaje != null) {
            req.setAttribute("mensaje", flashMensaje);
            session.removeAttribute("mensaje");
        }

        Object flashError = session.getAttribute("error");
        if (flashError != null) {
            req.setAttribute("error", flashError);
            session.removeAttribute("error");
        }

        String idParam = req.getParameter("id");
        Long id;
        try {
            id = idParam == null ? null : Long.parseLong(idParam);
        } catch (NumberFormatException ex) {
            id = null;
        }

        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/estudiantes");
            return;
        }

        Optional<Usuario> usuarioOpt = usuarioRepository.findById(id);
        if (usuarioOpt.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/estudiantes");
            return;
        }

        req.setAttribute("estudianteDetalle", usuarioOpt.get());
        req.getRequestDispatcher("/WEB-INF/jsp/admin/detalle-estudiante.jsp").forward(req, resp);
    }
}

