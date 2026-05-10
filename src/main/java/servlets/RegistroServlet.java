package servlets;

import Enums.Carrera;
import Enums.Estados;
import Enums.MateriasCatalogo;
import Enums.Rol;
import Enums.Semestre;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import repositories.AdminRepository;
import repositories.UsuarioRepository;
import schemas.Usuario;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

@WebServlet(name = "registroServlet", urlPatterns = "/registro")
public class RegistroServlet extends HttpServlet {
    private final UsuarioRepository usuarioRepository = new UsuarioRepository();
    private final AdminRepository adminRepository = new AdminRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("semestres", Semestre.values());
        req.setAttribute("carreras", Carrera.values());
        req.setAttribute("materiasPorCarreraJson", MateriasCatalogo.toJsonPorCarrera());
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
        String semestreStr = ServletUtils.value(req.getParameter("semestre"));
        String carreraStr = ServletUtils.value(req.getParameter("carrera"));

        req.setAttribute("semestres", Semestre.values());
        req.setAttribute("carreras", Carrera.values());
        req.setAttribute("materiasPorCarreraJson", MateriasCatalogo.toJsonPorCarrera());

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
            Long idPersona = null;

            Semestre semestre = null;
            if (!semestreStr.isBlank()) {
                semestre = Semestre.valueOf(semestreStr);
            }
            Carrera carreraRegistro = null;
            if (!carreraStr.isBlank()) {
                carreraRegistro = Carrera.valueOf(carreraStr);
            }

            if (rol == Rol.ESTUDIANTE) {
                schemas.Estudiante est = schemas.Estudiante.builder()
                        .nombre(nombre)
                        .segundoNombre(segundoNombre)
                        .apellido(apellido)
                        .segundoApellido(segundoApellido)
                        .estado(Estados.ACTIVO)
                        .semestre(semestre)
                        .carrera(carreraRegistro)
                        .build();
                savePersona(est);
                idPersona = est.getId();
            } else if (rol == Rol.TUTOR) {
                if (carreraRegistro == null) {
                    req.setAttribute("error", "Debes seleccionar tu carrera para registrar materias como tutor.");
                    req.getRequestDispatcher("/registro.jsp").forward(req, resp);
                    return;
                }
                String[] materiasParam = req.getParameterValues("materias");
                Set<String> codigos = new HashSet<>();
                if (materiasParam != null) {
                    for (String m : materiasParam) {
                        if (m == null || m.isBlank()) {
                            continue;
                        }
                        boolean ok = false;
                        for (MateriasCatalogo.Opcion op : MateriasCatalogo.porCarrera(carreraRegistro)) {
                            if (op.getCodigo().equalsIgnoreCase(m.trim())) {
                                codigos.add(op.getCodigo());
                                ok = true;
                                break;
                            }
                        }
                        if (!ok) {
                            req.setAttribute("error", "Una o más materias no corresponden a la carrera seleccionada.");
                            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
                            return;
                        }
                    }
                }
                if (codigos.isEmpty()) {
                    req.setAttribute("error", "Debes seleccionar al menos una materia relacionada.");
                    req.getRequestDispatcher("/registro.jsp").forward(req, resp);
                    return;
                }
                schemas.Tutor tutor = schemas.Tutor.builder()
                        .nombre(nombre)
                        .segundoNombre(segundoNombre)
                        .apellido(apellido)
                        .segundoApellido(segundoApellido)
                        .estado(Estados.ACTIVO)
                        .carrera(carreraRegistro)
                        .codigosMateriaRelacionadas(codigos)
                        .build();
                savePersona(tutor);
                idPersona = tutor.getId();
            }

            Usuario nuevoUsuario = Usuario.builder()
                    .email(email)
                    .password(password)
                    .rol(rol)
                    .idPersona(idPersona)
                    .build();

            usuarioRepository.save(nuevoUsuario);
            resp.sendRedirect(req.getContextPath() + "/login?mensaje=Registro+exitoso.+Ya+puedes+iniciar+sesion.");

        } catch (IllegalArgumentException e) {
            req.setAttribute("error", "Rol, carrera o semestre no válido.");
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Error al procesar el registro: " + e.getMessage());
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
        }
    }

    private void savePersona(Object persona) {
        jakarta.persistence.EntityManager em = repositories.JpaUtil.createEntityManager();
        jakarta.persistence.EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(persona);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
}
