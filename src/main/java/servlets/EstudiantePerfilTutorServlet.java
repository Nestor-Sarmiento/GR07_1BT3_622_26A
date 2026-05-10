package servlets;

import Enums.MateriaFIS;
import Enums.Rol;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repositories.JpaUtil;
import schemas.Estudiante;
import schemas.Tutor;
import schemas.Usuario;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Optional;

/**
 * Vista de perfil de un tutor para el estudiante (solo lectura).
 * GET /estudiante/tutor/perfil?id={id_tutor}
 */
@WebServlet(name = "estudiantePerfilTutorServlet", urlPatterns = "/estudiante/tutor/perfil")
public class EstudiantePerfilTutorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("usuarioLogueado") instanceof Usuario estudiante)
                || estudiante.getRol() != Rol.ESTUDIANTE) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String idStr = ServletUtils.value(req.getParameter("id"));
        if (idStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/estudiante/buscar-tutor");
            return;
        }

        long idTutor;
        try {
            idTutor = Long.parseLong(idStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/estudiante/buscar-tutor");
            return;
        }

        try (EntityManager em = JpaUtil.createEntityManager()) {
            Tutor tutor = em.find(Tutor.class, idTutor);
            if (tutor == null) {
                resp.sendRedirect(req.getContextPath() + "/estudiante/buscar-tutor");
                return;
            }

            Optional<String> emailTutor = em.createQuery(
                            "SELECT u.email FROM Usuario u WHERE u.idPersona = :pid AND u.rol = :rol", String.class)
                    .setParameter("pid", idTutor)
                    .setParameter("rol", Rol.TUTOR)
                    .setMaxResults(1)
                    .getResultStream()
                    .findFirst();

            req.setAttribute("tutorVer", tutor);
            req.setAttribute("tutorEmail", emailTutor.orElse(null));
            if (tutor.getMateriasRelacionadas() != null) {
                var ordenadas = new ArrayList<>(tutor.getMateriasRelacionadas());
                ordenadas.sort(Comparator.comparing(MateriaFIS::getNombre, String.CASE_INSENSITIVE_ORDER));
                req.setAttribute("materiasTutorOrdenadas", ordenadas);
            } else {
                req.setAttribute("materiasTutorOrdenadas", new ArrayList<MateriaFIS>());
            }

            if (estudiante.getIdPersona() != null) {
                Estudiante estudiantePerfil = em.find(Estudiante.class, estudiante.getIdPersona());
                req.setAttribute("estudiantePerfil", estudiantePerfil);
            }
        }

        req.setAttribute("materiaVolver", ServletUtils.value(req.getParameter("materia")));
        req.getRequestDispatcher("/WEB-INF/jsp/estudiante/perfil-tutor-estudiante.jsp").forward(req, resp);
    }
}
