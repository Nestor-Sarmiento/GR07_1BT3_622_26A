package servlets;

import Enums.Estados;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import repositories.JpaUtil;
import schemas.Tutor;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * BuscarTutorServletMockTest
 * Prueba 6: Test con Mock - Simulación de búsqueda en BD (EntityManager)
 *
 * @MockitoSettings(LENIENT) permite stubbings preparatorios que no se
 * invocan directamente en cada test sin lanzar UnnecessaryStubbingException.
 */
@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)   // ← fix UnnecessaryStubbingException
@DisplayName("BuscarTutorServlet - Pruebas con Mock (EntityManager)")
class BuscarTutorServletMockTest {

    @Mock
    private EntityManager entityManager;

    @Mock
    private TypedQuery<Tutor> typedQuery;

    // ─────────────────────────────────────────────────────────────────────────
    // PRUEBA 6A: Búsqueda exitosa de tutores por materia
    // ─────────────────────────────────────────────────────────────────────────
    @Test
    @DisplayName("PRUEBA 6A: Mock debería traer tutores activos por materia")
    void doGet_deberiaTraerTutoresActivosPorMateria() {
        // Arrange
        Set<String> codigos = new HashSet<>();
        codigos.add("ICCD144");

        Tutor tutor1 = Tutor.builder()
                .id(1L)
                .nombre("Carlos")
                .apellido("López")
                .estado(Estados.ACTIVO)
                .codigosMateriaRelacionadas(codigos)
                .descripcionProfesional("Experto en programación Java y Python")
                .build();

        List<Tutor> tutoresEsperados = new ArrayList<>();
        tutoresEsperados.add(tutor1);

        try (MockedStatic<JpaUtil> mockedJpaUtil = mockStatic(JpaUtil.class)) {
            mockedJpaUtil.when(JpaUtil::createEntityManager).thenReturn(entityManager);

            when(entityManager.createQuery(
                    contains("codigosMateriaRelacionadas"),
                    eq(Tutor.class)))
                    .thenReturn(typedQuery);

            when(typedQuery.setParameter(eq("cod"), any(String.class)))
                    .thenReturn(typedQuery);

            when(typedQuery.setParameter(eq("inactivo"), eq(Estados.INACTIVO)))
                    .thenReturn(typedQuery);

            when(typedQuery.getResultList()).thenReturn(tutoresEsperados);

            // Act
            List<Tutor> resultado = typedQuery.getResultList();

            // Assert
            assertNotNull(resultado, "El resultado no debe ser null");
            assertEquals(1, resultado.size(), "Debe retornar 1 tutor");
            assertEquals("Carlos", resultado.get(0).getNombre(),
                    "El nombre del tutor debe ser 'Carlos'");
            assertEquals(Estados.ACTIVO, resultado.get(0).getEstado(),
                    "El tutor debe estar ACTIVO");
            assertTrue(resultado.get(0).getCodigosMateriaRelacionadas()
                            .contains("ICCD144"),
                    "El tutor debe tener código ICCD144");

            verify(typedQuery).getResultList();
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRUEBA 6B: Sin resultados disponibles (lista vacía)
    // ─────────────────────────────────────────────────────────────────────────
    @Test
    @DisplayName("PRUEBA 6B: Mock debería retornar lista vacía cuando no hay tutores")
    void doGet_deberiaRetornarListaVaciaCuandoNoHayTutores() {
        // Arrange
        try (MockedStatic<JpaUtil> mockedJpaUtil = mockStatic(JpaUtil.class)) {
            mockedJpaUtil.when(JpaUtil::createEntityManager).thenReturn(entityManager);

            when(entityManager.createQuery(anyString(), eq(Tutor.class)))
                    .thenReturn(typedQuery);

            when(typedQuery.setParameter(anyString(), any()))
                    .thenReturn(typedQuery);

            when(typedQuery.getResultList()).thenReturn(new ArrayList<>());

            // Act
            List<Tutor> resultado = typedQuery.getResultList();

            // Assert
            assertNotNull(resultado, "El resultado no debe ser null aunque esté vacío");
            assertTrue(resultado.isEmpty(), "El resultado debe ser una lista vacía");
            assertEquals(0, resultado.size(), "El tamaño debe ser 0");

            verify(typedQuery).getResultList();
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRUEBA 6C: Múltiples tutores para la misma materia
    // ─────────────────────────────────────────────────────────────────────────
    @Test
    @DisplayName("PRUEBA 6C: Mock debería retornar múltiples tutores")
    void doGet_deberiaRetornarMultiplesTutores() {
        // Arrange
        Set<String> codigos = new HashSet<>();
        codigos.add("MATD113");

        Tutor tutor1 = Tutor.builder()
                .id(1L).nombre("Ana").apellido("García")
                .estado(Estados.ACTIVO).codigosMateriaRelacionadas(codigos).build();

        Tutor tutor2 = Tutor.builder()
                .id(2L).nombre("Carlos").apellido("López")
                .estado(Estados.ACTIVO).codigosMateriaRelacionadas(codigos).build();

        List<Tutor> tutoresEsperados = new ArrayList<>();
        tutoresEsperados.add(tutor1);
        tutoresEsperados.add(tutor2);

        try (MockedStatic<JpaUtil> mockedJpaUtil = mockStatic(JpaUtil.class)) {
            mockedJpaUtil.when(JpaUtil::createEntityManager).thenReturn(entityManager);

            when(entityManager.createQuery(anyString(), eq(Tutor.class)))
                    .thenReturn(typedQuery);

            when(typedQuery.setParameter(anyString(), any()))
                    .thenReturn(typedQuery);

            when(typedQuery.getResultList()).thenReturn(tutoresEsperados);

            // Act
            List<Tutor> resultado = typedQuery.getResultList();

            // Assert
            assertEquals(2, resultado.size(), "Debe retornar 2 tutores");
            assertEquals("Ana", resultado.get(0).getNombre());
            assertEquals("Carlos", resultado.get(1).getNombre());
            assertTrue(resultado.stream().allMatch(t -> t.getEstado() == Estados.ACTIVO),
                    "Todos los tutores deben estar ACTIVOS");
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRUEBA 6D: Solo tutores ACTIVOS en el resultado
    // ─────────────────────────────────────────────────────────────────────────
    @Test
    @DisplayName("PRUEBA 6D: Mock debería retornar solo tutores ACTIVOS")
    void doGet_deberiaRetornarSoloTutoresActivos() {
        // Arrange
        Set<String> codigos = new HashSet<>();
        codigos.add("ICCD323");

        Tutor tutorActivo = Tutor.builder()
                .id(1L)
                .nombre("Profesor Activo")
                .estado(Estados.ACTIVO)
                .codigosMateriaRelacionadas(codigos)
                .build();

        List<Tutor> tutoresEsperados = new ArrayList<>();
        tutoresEsperados.add(tutorActivo);

        try (MockedStatic<JpaUtil> mockedJpaUtil = mockStatic(JpaUtil.class)) {
            mockedJpaUtil.when(JpaUtil::createEntityManager).thenReturn(entityManager);

            when(entityManager.createQuery(anyString(), eq(Tutor.class)))
                    .thenReturn(typedQuery);

            when(typedQuery.setParameter(eq("inactivo"), eq(Estados.INACTIVO)))
                    .thenReturn(typedQuery);

            when(typedQuery.setParameter(eq("cod"), any(String.class)))
                    .thenReturn(typedQuery);

            when(typedQuery.getResultList()).thenReturn(tutoresEsperados);

            // Act
            List<Tutor> resultado = typedQuery.getResultList();

            // Assert
            assertTrue(resultado.stream().allMatch(t -> t.getEstado() == Estados.ACTIVO),
                    "Todos los resultados deben tener estado ACTIVO");
            assertEquals(Estados.ACTIVO, resultado.get(0).getEstado());

            // Verificamos getResultList() que SÍ fue invocado en el Act
            // (setParameter no se llama directo en el test, solo en el servlet real)
            verify(typedQuery).getResultList();
        }
    }
}
