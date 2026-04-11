package epn.servlets;

import epn.Enums.Estados;
import epn.Enums.Rol;
import epn.repositories.UsuarioRepository;
import epn.schemas.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "usuarioServlet", urlPatterns = "/usuarios")
public class UsuarioServlet extends HttpServlet {
    private final UsuarioRepository usuarioRepository = new UsuarioRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("usuarios", usuarioRepository.findAll());
        req.getRequestDispatcher("/WEB-INF/jsp/usuarios.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Usuario usuario = Usuario.builder()
                .email(req.getParameter("email"))
                .nombre(req.getParameter("nombre"))
                .apellido(req.getParameter("apellido"))
                .password(req.getParameter("password"))
                .rol(Rol.ADMIN)
                .estado(Estados.ACTIVO)
                .build();

        usuarioRepository.save(usuario);
        resp.sendRedirect(req.getContextPath() + "/usuarios");
    }
}

