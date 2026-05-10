package servlets;

import repositories.UsuarioRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import schemas.Admin;
import schemas.Estudiante;
import schemas.Usuario;
import schemas.UsuarioDTO;
import services.EstudianteService;
import repositories.JpaUtil;

import jakarta.persistence.EntityManager;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "estudianteServlet", urlPatterns = "/estudiantes")
public class EstudianteServlet extends HttpServlet {
    private final UsuarioRepository usuarioRepository = new UsuarioRepository();
    private final EstudianteService estudianteService = new EstudianteService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("adminLogueado") instanceof Usuario adminUser)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (adminUser.getIdPersona() != null) {
            try (EntityManager em = JpaUtil.createEntityManager()) {
                Admin adminPerfil = em.find(Admin.class, adminUser.getIdPersona());
                req.setAttribute("adminPerfil", adminPerfil);
            }
        }

        List<Usuario> listUsers = estudianteService.obtenerTodos(usuarioRepository);
        List<UsuarioDTO> dtos = new ArrayList<>();

        try (EntityManager em = JpaUtil.createEntityManager()) {
            for (Usuario u : listUsers) {
                UsuarioDTO dto = UsuarioDTO.builder()
                        .id_usuario(u.getId_usuario())
                        .email(u.getEmail())
                        .rol(u.getRol().toString())
                        .idPersona(u.getIdPersona())
                        .build();

                if (u.getIdPersona() != null) {
                    Estudiante est = em.find(Estudiante.class, u.getIdPersona());
                    if (est != null) {
                        dto.setNombre(est.getNombre());
                        dto.setApellido(""); // Estudiante record might not have apellido
                    }
                }
                dtos.add(dto);
            }
        }

        req.setAttribute("estudiantes", dtos);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/estudiantes.jsp").forward(req, resp);
    }
}
