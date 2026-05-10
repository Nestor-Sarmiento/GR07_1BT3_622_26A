package servlets;

import Enums.Estados;
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
import schemas.TutorListadoDTO;
import schemas.Usuario;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

@WebServlet(name = "buscarTutorServlet", urlPatterns = "/estudiante/buscar-tutor")
public class BuscarTutorServlet extends HttpServlet {

    private static final int BIO_MAX = 140;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("usuarioLogueado") instanceof Usuario estudiante)
                || estudiante.getRol() != Rol.ESTUDIANTE) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try (EntityManager em = JpaUtil.createEntityManager()) {
            Long idPersona = estudiante.getIdPersona();
            if (idPersona != null) {
                Estudiante estudiantePerfil = em.find(Estudiante.class, idPersona);
                req.setAttribute("estudiantePerfil", estudiantePerfil);
            }
        }

        String codigoParam = ServletUtils.value(req.getParameter("codigo"));
        if (codigoParam.isBlank()) {
            codigoParam = ServletUtils.value(req.getParameter("materia"));
        }
        req.setAttribute("codigoSeleccionadoParam", codigoParam);

        List<TutorListadoDTO> tutoresResultado = new ArrayList<>();
        if (!codigoParam.isBlank()) {
            Optional<MateriasCatalogo.Opcion> opOpt = MateriasCatalogo.buscarPorCodigo(codigoParam);
            if (opOpt.isEmpty()) {
                req.setAttribute("errorMateria", "La materia seleccionada no es válida.");
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
                        tutoresResultado.add(toDto(t));
                    }
                }
            }
        }

        req.setAttribute("tutoresResultado", tutoresResultado);
        req.setAttribute("materiasBusqueda", MateriasCatalogo.todasOpcionesBusqueda());
        req.getRequestDispatcher("/WEB-INF/jsp/estudiante/buscar-tutor.jsp").forward(req, resp);
    }

    private static TutorListadoDTO toDto(Tutor t) {
        String nombre = joinNombreParts(t.getNombre(), t.getSegundoNombre(), t.getApellido(), t.getSegundoApellido());
        String bio = t.getDescripcionProfesional();
        if (bio != null) {
            bio = bio.trim();
            if (bio.length() > BIO_MAX) {
                bio = bio.substring(0, BIO_MAX - 1) + "…";
            }
        }
        if (bio == null || bio.isEmpty()) {
            bio = "Tutor académico";
        }
        List<String> tags = t.getCodigosMateriaRelacionadas() == null ? List.of()
                : t.getCodigosMateriaRelacionadas().stream()
                .map(c -> MateriasCatalogo.buscarPorCodigo(c).map(MateriasCatalogo.Opcion::getNombre).orElse(c))
                .sorted(String.CASE_INSENSITIVE_ORDER)
                .collect(Collectors.toList());
        return TutorListadoDTO.builder()
                .idTutor(t.getId())
                .nombreMostrar(nombre.isEmpty() ? "Tutor" : nombre)
                .bioCorta(bio)
                .materiasEtiquetas(tags)
                .build();
    }

    private static String joinNombreParts(String... parts) {
        if (parts == null) {
            return "";
        }
        return java.util.Arrays.stream(parts)
                .filter(Objects::nonNull)
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .collect(Collectors.joining(" "));
    }
}
