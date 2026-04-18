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

@WebServlet(name = "usuarioDetalleServlet", urlPatterns = "/usuario/detalle")
public class UsuarioDetalleServlet extends HttpServlet {
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

        Long id = idDesdeRequest(req);
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/usuarios");
            return;
        }

        Optional<Usuario> usuarioOpt = usuarioRepository.findById(id);
        if (usuarioOpt.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/usuarios");
            return;
        }

        req.setAttribute("usuarioDetalle", usuarioOpt.get());
        req.getRequestDispatcher("/WEB-INF/jsp/admin/detalle-usuario.jsp").forward(req, resp);
    }


    private Long idDesdeRequest(HttpServletRequest req) {
        try {
            String id = req.getParameter("id");
            return id == null ? null : Long.parseLong(id);
        } catch (NumberFormatException ex) {
            return null;
        }
    }


}

