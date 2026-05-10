package servlets;

import Enums.Estados;
import Enums.Rol;
import repositories.UsuarioRepository;
import schemas.Usuario;
import schemas.Admin;
import schemas.Tutor;
import schemas.Estudiante;
import schemas.UsuarioDTO;
import repositories.JpaUtil;
import jakarta.persistence.EntityManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "usuarioServlet", urlPatterns = "/usuarios")
public class UsuarioServlet extends HttpServlet {
    private final UsuarioRepository usuarioRepository = new UsuarioRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("adminLogueado") != null) {
            Usuario adminUser = (Usuario) session.getAttribute("adminLogueado");
            if (adminUser.getIdPersona() != null) {
                try (EntityManager em = JpaUtil.createEntityManager()) {
                    Admin adminPerfil = em.find(Admin.class, adminUser.getIdPersona());
                    req.setAttribute("adminPerfil", adminPerfil);
                }
            }
        }

        List<Usuario> listUsers = usuarioRepository.findAll();
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
                    if (u.getRol() == Rol.ADMIN) {
                        Admin adm = em.find(Admin.class, u.getIdPersona());
                        if (adm != null) {
                            dto.setNombre(adm.getNombre());
                            dto.setApellido(adm.getApellido());
                        }
                    } else if (u.getRol() == Rol.TUTOR) {
                        Tutor tut = em.find(Tutor.class, u.getIdPersona());
                        if (tut != null) {
                            dto.setNombre(tut.getNombre());
                            dto.setApellido(tut.getApellido());
                        }
                    } else if (u.getRol() == Rol.ESTUDIANTE) {
                        Estudiante est = em.find(Estudiante.class, u.getIdPersona());
                        if (est != null) {
                            dto.setNombre(est.getNombre());
                            dto.setApellido(""); // Estudiante might not have 'apellido' field, check Estudiante.java
                        }
                    }
                }
                dtos.add(dto);
            }
        }

        req.setAttribute("usuarios", dtos);
        req.getRequestDispatcher("/WEB-INF/jsp/admin/usuarios.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = ServletUtils.value(req.getParameter("email"));
        String nombre = ServletUtils.value(req.getParameter("nombre"));
        String apellido = ServletUtils.value(req.getParameter("apellido"));
        String password = ServletUtils.value(req.getParameter("password"));

        jakarta.persistence.EntityManager em = repositories.JpaUtil.createEntityManager();
        jakarta.persistence.EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            // Para administradores creados desde la gestión de usuarios
            schemas.Admin internalAdmin = schemas.Admin.builder()
                    .nombre(nombre)
                    .apellido(apellido)
                    .estado(Estados.ACTIVO)
                    .build();
            em.persist(internalAdmin);

            Usuario usuario = Usuario.builder()
                    .email(email)
                    .password(password)
                    .rol(Rol.ADMIN)
                    .idPersona(internalAdmin.getId())
                    .build();
            em.persist(usuario);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }

        resp.sendRedirect(req.getContextPath() + "/usuarios");
    }
}
