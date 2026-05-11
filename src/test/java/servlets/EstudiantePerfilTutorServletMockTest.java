package servlets;

import Enums.Carrera;
import Enums.Rol;
import Enums.Semestre;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import schemas.Estudiante;
import schemas.Tutor;
import schemas.Usuario;

import java.io.IOException;
import java.util.Set;
import java.util.stream.Stream;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * PRUEBA 6: Test con Mocks — EstudiantePerfilTutorServlet
 *
 * Cubre los 3 escenarios de aceptación de la Historia de Usuario:
 *   - Escenario 1 (6A): Estudiante autenticado ve perfil completo de tutor existente
 *   - Escenario 2 (6B): Tutor sin materias/descripción → perfil igual se despliega
 *   - Escenario 3 (6C): Usuario no autenticado → redirige a /login
 *   - Extra     (6D): ID no numérico → redirige a buscar-tutor sin tocar BD
 *
 * REQUISITO: EstudiantePerfilTutorServlet debe tener el método buildEntityManager()
 * que delega a JpaUtil en producción pero puede sobreescribirse en tests.
 */
@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
@DisplayName("EstudiantePerfilTutorServlet - Prueba con Mocks")
class EstudiantePerfilTutorServletMockTest {

    @Mock private HttpServletRequest  request;
    @Mock private HttpServletResponse response;
    @Mock private HttpSession         session;
    @Mock private RequestDispatcher   dispatcher;
    @Mock private EntityManager       em;

    @Mock @SuppressWarnings("rawtypes")
    private TypedQuery emailQuery;

    private EstudiantePerfilTutorServlet servlet;
    private Usuario estudianteUsuario;
    private Tutor   tutorExistente;

    @BeforeEach
    @SuppressWarnings("unchecked")
    void setUp() {
        servlet = new EstudiantePerfilTutorServlet() {
            @Override
            protected EntityManager buildEntityManager() {
                return em;
            }
        };

        estudianteUsuario = Usuario.builder()
                .id_usuario(10L)
                .email("estudiante@epn.edu.ec")
                .rol(Rol.ESTUDIANTE)
                .idPersona(5L)
                .build();

        tutorExistente = Tutor.builder()
                .id(42L)
                .nombre("Carlos")
                .apellido("López")
                .descripcionProfesional("Experiencia en algoritmos y estructuras de datos.")
                .carrera(Carrera.SOFTWARE)
                .semestre(Semestre.QUINTO_SEMESTRE)
                .codigosMateriaRelacionadas(Set.of("ICCD144", "ICCD244"))
                .build();

        // LENIENT: estos stubs solo se usan en 6A y 6B, no en 6C/6D
        when(em.createQuery(anyString(), eq(String.class))).thenReturn(emailQuery);
        when(emailQuery.setParameter(anyString(), any())).thenReturn(emailQuery);
        when(emailQuery.setMaxResults(anyInt())).thenReturn(emailQuery);
        when(emailQuery.getResultStream()).thenReturn(Stream.of("carlos.lopez@epn.edu.ec"));
    }

    // ─────────────────────────────────────────────────────────────────────────
    // ESCENARIO 1 — Perfil completo con materias y email
    // ─────────────────────────────────────────────────────────────────────────

    @Test
    @DisplayName("PRUEBA 6A: Estudiante autenticado ve perfil completo del tutor con materias")
    @SuppressWarnings("unchecked")
    void doGet_estudianteAutenticado_deberiaMostrarPerfilCompletoDelTutor()
            throws ServletException, IOException {

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("usuarioLogueado")).thenReturn(estudianteUsuario);
        when(request.getParameter("id")).thenReturn("42");
        when(request.getParameter("codigo")).thenReturn("ICCD144");
        when(request.getParameter("materia")).thenReturn(null);
        when(request.getContextPath()).thenReturn("");
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);

        when(em.find(Tutor.class, 42L)).thenReturn(tutorExistente);
        Estudiante estudiantePerfil = Estudiante.builder()
                .id(5L).nombre("Ana").apellido("García").build();
        when(em.find(Estudiante.class, 5L)).thenReturn(estudiantePerfil);

        servlet.doGet(request, response);

        verify(request).setAttribute(eq("tutorVer"),               eq(tutorExistente));
        verify(request).setAttribute(eq("tutorEmail"),             eq("carlos.lopez@epn.edu.ec"));
        verify(request).setAttribute(eq("materiasTutorEtiquetas"), any());
        verify(request).setAttribute(eq("estudiantePerfil"),       eq(estudiantePerfil));
        verify(dispatcher).forward(request, response);
        verify(response, never()).sendRedirect(anyString());
    }

    // ─────────────────────────────────────────────────────────────────────────
    // ESCENARIO 2 — Tutor sin materias ni descripción
    // ─────────────────────────────────────────────────────────────────────────

    @Test
    @DisplayName("PRUEBA 6B: Tutor sin materias ni descripción — perfil se despliega con campos vacíos")
    @SuppressWarnings("unchecked")
    void doGet_tutorSinMateriasNiDescripcion_deberiaMostrarPerfilConCamposVacios()
            throws ServletException, IOException {

        Tutor tutorSinDatos = Tutor.builder()
                .id(99L)
                .nombre("Luis")
                .apellido("Pérez")
                .descripcionProfesional(null)
                .codigosMateriaRelacionadas(Set.of())
                .build();

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("usuarioLogueado")).thenReturn(estudianteUsuario);
        when(request.getParameter("id")).thenReturn("99");
        when(request.getParameter("codigo")).thenReturn(null);
        when(request.getParameter("materia")).thenReturn(null);
        when(request.getContextPath()).thenReturn("");
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);

        when(em.find(Tutor.class, 99L)).thenReturn(tutorSinDatos);
        when(em.find(Estudiante.class, 5L)).thenReturn(null);

        servlet.doGet(request, response);

        verify(request).setAttribute(eq("tutorVer"), eq(tutorSinDatos));
        verify(dispatcher).forward(request, response);
        verify(response, never()).sendRedirect(anyString());
    }

    // ─────────────────────────────────────────────────────────────────────────
    // ESCENARIO 3 — Sin sesión → redirige a /login
    // ─────────────────────────────────────────────────────────────────────────

    @Test
    @DisplayName("PRUEBA 6C: Sin sesión activa → redirige a /login")
    void doGet_sinSesion_deberiaRedirigirAlLogin()
            throws ServletException, IOException {

        when(request.getSession(false)).thenReturn(null);
        when(request.getContextPath()).thenReturn("");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/login");
        verify(em, never()).find(any(), any());
        verify(dispatcher, never()).forward(any(), any());
    }

    // ─────────────────────────────────────────────────────────────────────────
    // EXTRA — ID no numérico → redirige a buscar-tutor
    // ─────────────────────────────────────────────────────────────────────────

    @Test
    @DisplayName("PRUEBA 6D: ID no numérico → redirige a buscar-tutor sin tocar BD")
    void doGet_idNoNumerico_deberiaRedirigirABuscarTutor()
            throws ServletException, IOException {

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("usuarioLogueado")).thenReturn(estudianteUsuario);
        when(request.getParameter("id")).thenReturn("abc_invalido");
        when(request.getContextPath()).thenReturn("");

        servlet.doGet(request, response);

        verify(response).sendRedirect("/estudiante/buscar-tutor");
        verify(em, never()).find(any(), any());
    }
}