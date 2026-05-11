package servlets;

import Enums.Carrera;
import Enums.Estados;
import Enums.MateriasCatalogo;
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

        Estudiante estudiantePerfil = null;
        try (EntityManager em = JpaUtil.createEntityManager()) {
            Long idPersona = estudiante.getIdPersona();
            if (idPersona != null) {
                estudiantePerfil = em.find(Estudiante.class, idPersona);
            }
        }
        req.setAttribute("estudiantePerfil", estudiantePerfil);

        Carrera carreraEst = estudiantePerfil != null ? estudiantePerfil.getCarrera() : null;
        List<MateriasCatalogo.Opcion> materiasBusqueda = new ArrayList<>(MateriasCatalogo.porCarrera(carreraEst));
        materiasBusqueda.sort(Comparator.comparing(MateriasCatalogo.Opcion::getNombre, String.CASE_INSENSITIVE_ORDER));
        req.setAttribute("materiasBusqueda", materiasBusqueda);
        req.setAttribute("materiasAccesoRapido", materiasBusqueda.stream().limit(4).toList());

        String codigoParam = ServletUtils.value(req.getParameter("codigo"));
        if (codigoParam.isBlank()) {
            codigoParam = ServletUtils.value(req.getParameter("materia"));
        }
        final String codigoBuscar = codigoParam;
        req.setAttribute("codigoSeleccionadoParam", codigoBuscar);

        if (!codigoBuscar.isBlank()) {
            if (carreraEst == null) {
                req.setAttribute("errorMateria",
                        "Registra tu carrera en Mi perfil para buscar tutores por materias de tu plan.");
            } else {
                Optional<MateriasCatalogo.Opcion> opOpt = materiasBusqueda.stream()
                        .filter(o -> o.getCodigo().equalsIgnoreCase(codigoBuscar.trim()))
                        .findFirst();
                if (opOpt.isEmpty()) {
                    req.setAttribute("errorMateria", "Esa materia no corresponde a tu carrera. Elige una del listado.");
                } else {
                    MateriasCatalogo.Opcion op = opOpt.get();
                    req.setAttribute("materiaSeleccionada", op);
                    try (EntityManager em = JpaUtil.createEntityManager()) {
                        String codCanon = op.getCodigo();
                        /*
                         * JOIN sobre la colección es más fiable que MEMBER OF con @ElementCollection(Set<String>)
                         * en Hibernate 6. Se excluyen solo tutores INACTIVO; el resto (ACTIVO, POR_VERIFICAR, null)
                         * aparece en búsqueda para no ocultar cuentas por desajuste de estado en BD.
                         */
                        List<Tutor> encontrados = em.createQuery(
                                        "SELECT DISTINCT t FROM Tutor t JOIN t.codigosMateriaRelacionadas c "
                                                + "WHERE LOWER(TRIM(c)) = LOWER(TRIM(:cod)) "
                                                + "AND (t.estado IS NULL OR t.estado <> :inactivo)",
                                        Tutor.class)
                                .setParameter("cod", codCanon)
                                .setParameter("inactivo", Estados.INACTIVO)
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
        }

        req.setAttribute("tutoresResultado", tutoresResultado);
        req.getRequestDispatcher("/WEB-INF/jsp/estudiante/buscar-tutor.jsp").forward(req, resp);
    }
}
