package servlets;

import Enums.MateriasCatalogo;
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
import java.util.List;
import java.util.Optional;

/**
 * Vista de perfil de un tutor para el estudiante (solo lectura).
 * GET /estudiante/tutor/perfil?id={id_tutor}&codigo={opcional}
 */
@WebServlet(name = "estudiantePerfilTutorServlet", urlPatterns = "/estudiante/tutor/perfil")
public class EstudiantePerfilTutorServlet extends HttpServlet {

    /**
     * Hook para pruebas unitarias: sobreescribir este método permite
     * inyectar un EntityManager mockeado sin cambiar la lógica de negocio.
     */
    protected EntityManager buildEntityManager() {
        return JpaUtil.createEntityManager();
    }

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

        try (EntityManager em =  buildEntityManager()) {
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

            List<String> etiquetas = new ArrayList<>();
            if (tutor.getCodigosMateriaRelacionadas() != null) {
                for (String c : tutor.getCodigosMateriaRelacionadas()) {
                    etiquetas.add(MateriasCatalogo.buscarPorCodigo(c).map(MateriasCatalogo.Opcion::getNombre).orElse(c));
                }
                etiquetas.sort(Comparator.comparing(String::toString, String.CASE_INSENSITIVE_ORDER));
            }
            req.setAttribute("materiasTutorEtiquetas", etiquetas);

            if (estudiante.getIdPersona() != null) {
                Estudiante estudiantePerfil = em.find(Estudiante.class, estudiante.getIdPersona());
                req.setAttribute("estudiantePerfil", estudiantePerfil);
            }
        }

        String codigoVolver = ServletUtils.value(req.getParameter("codigo"));
        if (codigoVolver.isBlank()) {
            codigoVolver = ServletUtils.value(req.getParameter("materia"));
        }
        req.setAttribute("codigoVolver", codigoVolver);
        req.getRequestDispatcher("/WEB-INF/jsp/estudiante/perfil-tutor-estudiante.jsp").forward(req, resp);
    }
}
