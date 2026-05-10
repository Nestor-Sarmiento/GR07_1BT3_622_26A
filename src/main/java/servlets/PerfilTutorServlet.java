package servlets;

import Enums.MateriaFIS;
import Enums.Rol;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repositories.JpaUtil;
import schemas.Tutor;
import schemas.Usuario;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashSet;
import java.util.Set;

@WebServlet(name = "perfilTutorServlet", urlPatterns = "/tutor/perfil")
public class PerfilTutorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("usuarioLogueado") instanceof Usuario usuario)
                || usuario.getRol() != Rol.TUTOR) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String mensaje = ServletUtils.value(req.getParameter("mensaje"));
        if (!mensaje.isEmpty()) {
            req.setAttribute("flashOk", mensaje);
        }
        String error = ServletUtils.value(req.getParameter("error"));
        if (!error.isEmpty()) {
            req.setAttribute("flashError", error);
        }

        if (usuario.getIdPersona() != null) {
            try (EntityManager em = JpaUtil.createEntityManager()) {
                Tutor tutorPerfil = em.find(Tutor.class, usuario.getIdPersona());
                req.setAttribute("tutorPerfil", tutorPerfil);
            }
        }

        req.setAttribute("materias", MateriaFIS.values());
        req.getRequestDispatcher("/WEB-INF/jsp/tutor/perfil-tutor.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("usuarioLogueado") instanceof Usuario usuario)
                || usuario.getRol() != Rol.TUTOR || usuario.getIdPersona() == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String accion = ServletUtils.value(req.getParameter("accion"));
        String redirectBase = req.getContextPath() + "/tutor/perfil";

        try (EntityManager em = JpaUtil.createEntityManager()) {
            EntityTransaction tx = em.getTransaction();
            tx.begin();
            try {
                Tutor tutor = em.find(Tutor.class, usuario.getIdPersona());
                if (tutor == null) {
                    tx.rollback();
                    resp.sendRedirect(redirectBase + "?error=" + url("No se encontró el perfil de tutor."));
                    return;
                }

                switch (accion) {
                    case "materias" -> {
                        String raw = req.getParameter("materias");
                        Set<MateriaFIS> nuevas = new HashSet<>();
                        if (raw != null && !raw.isBlank()) {
                            for (String part : raw.split(",")) {
                                String p = part.trim();
                                if (p.isEmpty()) {
                                    continue;
                                }
                                nuevas.add(MateriaFIS.valueOf(p));
                            }
                        }
                        tutor.setMateriasRelacionadas(nuevas);
                        em.merge(tutor);
                    }
                    case "bio" -> {
                        String bio = ServletUtils.value(req.getParameter("bio"));
                        tutor.setDescripcionProfesional(bio);
                        em.merge(tutor);
                    }
                    case "nombre" -> {
                        String nombre = ServletUtils.value(req.getParameter("nombre"));
                        if (!nombre.isBlank()) {
                            tutor.setNombre(nombre);
                        }
                        em.merge(tutor);
                    }
                    default -> {
                        tx.rollback();
                        resp.sendRedirect(redirectBase + "?error=" + url("Acción no válida."));
                        return;
                    }
                }
                tx.commit();
            } catch (RuntimeException e) {
                if (tx.isActive()) {
                    tx.rollback();
                }
                throw e;
            }
        } catch (IllegalArgumentException e) {
            resp.sendRedirect(redirectBase + "?error=" + url("Una o más materias no son válidas."));
            return;
        } catch (Exception e) {
            resp.sendRedirect(redirectBase + "?error=" + url("No se pudo guardar: " + e.getMessage()));
            return;
        }

        String okMsg = switch (accion) {
            case "materias" -> "Materias relacionadas guardadas.";
            case "bio" -> "Descripción profesional guardada.";
            case "nombre" -> "Nombre actualizado.";
            default -> "Cambios guardados.";
        };
        resp.sendRedirect(redirectBase + "?mensaje=" + url(okMsg));
    }

    private static String url(String s) {
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }
}
