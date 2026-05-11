package servlets;

import Enums.Estados;
import Enums.MateriaFIS;
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
import schemas.TutorListadoDTO;
import schemas.TutorListadoMapper;
import schemas.Usuario;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "buscarTutorServlet", urlPatterns = "/estudiante/buscar-tutor")
public class BuscarTutorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Optional<Usuario> estudianteOpt = ServletUtils.estudianteDesdeSesion(session);
        if (estudianteOpt.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        Usuario estudiante = estudianteOpt.get();

        String materiaParam = ServletUtils.value(req.getParameter("materia"));
        req.setAttribute("materiaSeleccionadaParam", materiaParam);

        List<TutorListadoDTO> tutoresResultado = new ArrayList<>();

        try (EntityManager em = JpaUtil.createEntityManager()) {
            Long idPersona = estudiante.getIdPersona();
            if (idPersona != null) {
                Estudiante estudiantePerfil = em.find(Estudiante.class, idPersona);
                req.setAttribute("estudiantePerfil", estudiantePerfil);
            }

            if (!materiaParam.isBlank()) {
                try {
                    MateriaFIS mf = MateriaFIS.valueOf(materiaParam);
                    req.setAttribute("materiaSeleccionada", mf);
                    List<Tutor> encontrados = em.createQuery(
                            "SELECT DISTINCT t FROM Tutor t WHERE :m MEMBER OF t.materiasRelacionadas AND t.estado = :activo",
                            Tutor.class)
                            .setParameter("m", mf)
                            .setParameter("activo", Estados.ACTIVO)
                            .getResultList();
                    encontrados.sort(Comparator.comparing(Tutor::getNombre, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER)));
                    for (Tutor t : encontrados) {
                        tutoresResultado.add(TutorListadoMapper.toDto(t));
                    }
                } catch (IllegalArgumentException e) {
                    req.setAttribute("errorMateria", "La materia seleccionada no es válida.");
                }
            }
        }

        req.setAttribute("tutoresResultado", tutoresResultado);
        req.setAttribute("materias", MateriaFIS.values());
        req.getRequestDispatcher("/WEB-INF/jsp/estudiante/buscar-tutor.jsp").forward(req, resp);
    }
}
