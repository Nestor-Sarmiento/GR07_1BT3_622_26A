package servlets;

import Enums.Estados;
import Enums.Rol;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import repositories.AdminRepository;
import repositories.UsuarioRepository;
import schemas.Admin;
import schemas.Usuario;

import java.io.IOException;

@WebServlet(name = "registroServlet", urlPatterns = "/registro")
public class RegistroServlet extends HttpServlet {
    private final UsuarioRepository usuarioRepository = new UsuarioRepository();
    private final AdminRepository adminRepository = new AdminRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/registro.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = ServletUtils.value(req.getParameter("email"));
        String password = ServletUtils.value(req.getParameter("password"));
        String nombre = ServletUtils.value(req.getParameter("nombre"));
        String segundoNombre = ServletUtils.value(req.getParameter("segundoNombre"));
        String apellido = ServletUtils.value(req.getParameter("apellido"));
        String segundoApellido = ServletUtils.value(req.getParameter("segundoApellido"));
        String rolStr = ServletUtils.value(req.getParameter("rol"));

        if (email.isBlank() || password.isBlank() || nombre.isBlank() || apellido.isBlank() || rolStr.isBlank()) {
            req.setAttribute("error", "Todos los campos marcados como obligatorios (*) son requeridos.");
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
            return;
        }

        if (adminRepository.existsByEmail(email)) {
            req.setAttribute("error", "El correo electrónico ya se encuentra registrado.");
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
            return;
        }

        try {
            Rol rol = Rol.valueOf(rolStr.toUpperCase());

            Usuario nuevoUsuario = Usuario.builder()
                    .email(email)
                    .password(password)
                    .nombre(nombre)
                    .segundoNombre(segundoNombre)
                    .apellido(apellido)
                    .segundoApellido(segundoApellido)
                    .rol(rol)
                    .estado(Estados.ACTIVO)
                    .build();

            usuarioRepository.save(nuevoUsuario);
            resp.sendRedirect(req.getContextPath() + "/login?mensaje=Registro+exitoso.+Ya+puedes+iniciar+sesion.");

        } catch (IllegalArgumentException e) {
            req.setAttribute("error", "Rol no válido seleccionado.");
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Error al procesar el registro: " + e.getMessage());
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
        }
    }
}
