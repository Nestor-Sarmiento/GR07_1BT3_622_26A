package servlets;

import Enums.Carrera;
import Enums.MateriasCatalogo;
import Enums.Rol;
import Enums.Semestre;
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
import java.util.Optional;
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

        try (EntityManager emFresh = JpaUtil.createEntityManager()) {
            Usuario desdeBd = emFresh.find(Usuario.class, usuario.getId_usuario());
            if (desdeBd != null && desdeBd.getRol() == Rol.TUTOR) {
                session.setAttribute("usuarioLogueado", desdeBd);
                usuario = desdeBd;
            }
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

        req.setAttribute("carreras", Carrera.values());
        req.setAttribute("semestres", Semestre.values());
        req.setAttribute("materiasPorCarreraJson", MateriasCatalogo.toJsonPorCarrera());
        req.getRequestDispatcher("/WEB-INF/jsp/tutor/perfil-tutor.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !(session.getAttribute("usuarioLogueado") instanceof Usuario sesionUser)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (sesionUser.getRol() != Rol.TUTOR) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String redirectBase = req.getContextPath() + "/tutor/perfil";

        /* Sesión puede estar desactualizada respecto a la BD (p. ej. id_persona asignado después del login). */
        Usuario usuario;
        try (EntityManager emReload = JpaUtil.createEntityManager()) {
            usuario = emReload.find(Usuario.class, sesionUser.getId_usuario());
        }
        if (usuario == null || usuario.getRol() != Rol.TUTOR) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (usuario.getIdPersona() == null) {
            resp.sendRedirect(redirectBase + "?error="
                    + url("Tu cuenta no tiene un perfil de tutor vinculado (id persona). Contacta al administrador."));
            return;
        }
        session.setAttribute("usuarioLogueado", usuario);

        String accion = ServletUtils.value(req.getParameter("accion"));

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
                    case "semestre" -> {
                        String semStr = ServletUtils.value(req.getParameter("semestre"));
                        if (semStr.isBlank()) {
                            tx.rollback();
                            resp.sendRedirect(redirectBase + "?error=" + url("Selecciona tu semestre."));
                            return;
                        }
                        Semestre sem = Semestre.valueOf(semStr);
                        tutor.setSemestre(sem);
                        Set<String> filtradas = new HashSet<>();
                        Carrera carActual = tutor.getCarrera();
                        if (tutor.getCodigosMateriaRelacionadas() != null && carActual != null) {
                            for (String cod : tutor.getCodigosMateriaRelacionadas()) {
                                Optional<MateriasCatalogo.Opcion> canon = MateriasCatalogo
                                        .porCarreraParaTutor(carActual, sem).stream()
                                        .filter(o -> o.getCodigo().equalsIgnoreCase(cod))
                                        .findFirst();
                                canon.ifPresent(o -> filtradas.add(o.getCodigo()));
                            }
                        }
                        tutor.setCodigosMateriaRelacionadas(filtradas);
                        em.merge(tutor);
                    }
                    case "materias" -> {
                        if (tutor.getSemestre() == null) {
                            tx.rollback();
                            resp.sendRedirect(redirectBase + "?error="
                                    + url("Primero guarda el semestre que cursas."));
                            return;
                        }
                        String carreraStr = ServletUtils.value(req.getParameter("carrera"));
                        if (carreraStr.isBlank()) {
                            tx.rollback();
                            resp.sendRedirect(redirectBase + "?error=" + url("Selecciona tu carrera."));
                            return;
                        }
                        Carrera car = Carrera.valueOf(carreraStr);
                        Semestre semTutor = tutor.getSemestre();
                        String raw = req.getParameter("materias");
                        Set<String> nuevas = new HashSet<>();
                        if (raw != null && !raw.isBlank()) {
                            for (String part : raw.split(",")) {
                                String p = part.trim();
                                if (p.isEmpty()) {
                                    continue;
                                }
                                boolean ok = false;
                                for (MateriasCatalogo.Opcion op : MateriasCatalogo.porCarreraParaTutor(car, semTutor)) {
                                    if (op.getCodigo().equalsIgnoreCase(p)) {
                                        nuevas.add(op.getCodigo());
                                        ok = true;
                                        break;
                                    }
                                }
                                if (!ok) {
                                    tx.rollback();
                                    resp.sendRedirect(redirectBase + "?error="
                                            + url("Una o más materias no son válidas para tu carrera y semestre "
                                                    + "(solo asignaturas de semestres anteriores al tuyo)."));
                                    return;
                                }
                            }
                        }
                        tutor.setCarrera(car);
                        tutor.setCodigosMateriaRelacionadas(nuevas);
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
            case "semestre" -> "Semestre actualizado. Se ajustaron las materias a las permitidas.";
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
