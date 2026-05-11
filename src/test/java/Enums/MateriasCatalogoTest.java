package Enums;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.*;

/**
 * MateriasCatalogoTest
 * PRUEBA 2: buscarPorCodigo() — código válido, inválido, null, blank
 * PRUEBA 3: codigoPerteneceACarrera() — casos normales y bordes
 * PRUEBA 4: porCarreraParaTutor() — filtrado por semestre
 * PRUEBA 5: codigoPermitidoParaTutor() — test parametrizado (5 casos)
 */
@DisplayName("MateriasCatalogo - Pruebas unitarias y parametrizadas")
class MateriasCatalogoTest {

    // ─────────────────────────────────────────────────────────────────────────
    // PRUEBA 2: buscarPorCodigo()
    // ─────────────────────────────────────────────────────────────────────────

    @Test
    @DisplayName("PRUEBA 2: buscarPorCodigo() debe encontrar código válido y retornar vacío para inválidos")
    void buscarPorCodigo_deberiaEncontrarCodigoValidoYRetornarVacioParaInvalido() {
        // Obtener un código real del catálogo de forma dinámica
        String codigoReal = MateriasCatalogo.porCarrera(Carrera.SOFTWARE)
                .stream()
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("Catálogo SOFTWARE vacío"))
                .getCodigo();

        // Caso 1: código válido → Optional presente con el mismo código
        Optional<MateriasCatalogo.Opcion> resultado = MateriasCatalogo.buscarPorCodigo(codigoReal);
        assertTrue(resultado.isPresent(),
                "Debe encontrar el código: " + codigoReal);
        assertEquals(codigoReal.toUpperCase(), resultado.get().getCodigo().toUpperCase(),
                "El código retornado debe coincidir");

        // Caso 2: código inválido → Optional vacío
        assertTrue(MateriasCatalogo.buscarPorCodigo("CODIGO_QUE_NO_EXISTE").isEmpty(),
                "Código inválido debe retornar Optional vacío");

        // Caso 3: null → Optional vacío
        assertTrue(MateriasCatalogo.buscarPorCodigo(null).isEmpty(),
                "null debe retornar Optional vacío");

        // Caso 4: blank → Optional vacío
        assertTrue(MateriasCatalogo.buscarPorCodigo("   ").isEmpty(),
                "Blank debe retornar Optional vacío");
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRUEBA 3: codigoPerteneceACarrera()
    // ─────────────────────────────────────────────────────────────────────────

    @Test
    @DisplayName("PRUEBA 3: codigoPerteneceACarrera() debe validar pertenencia correctamente")
    void codigoPerteneceACarrera_deberiaValidarPertenenciaCorrectamente() {
        // Obtener un código real de SOFTWARE
        String codigoSoftware = MateriasCatalogo.porCarrera(Carrera.SOFTWARE)
                .stream()
                .findFirst()
                .orElseThrow()
                .getCodigo();

        // Caso 1: código que pertenece a la carrera → true
        assertTrue(MateriasCatalogo.codigoPerteneceACarrera(codigoSoftware, Carrera.SOFTWARE),
                "El código debe pertenecer a SOFTWARE");

        // Caso 2: código null → false
        assertFalse(MateriasCatalogo.codigoPerteneceACarrera(null, Carrera.SOFTWARE),
                "null código debe retornar false");

        // Caso 3: carrera null → false
        assertFalse(MateriasCatalogo.codigoPerteneceACarrera(codigoSoftware, null),
                "null carrera debe retornar false");

        // Caso 4: código completamente inválido → false
        assertFalse(MateriasCatalogo.codigoPerteneceACarrera("XXXX999", Carrera.SOFTWARE),
                "Código inexistente debe retornar false");

        // Caso 5: código blank → false
        assertFalse(MateriasCatalogo.codigoPerteneceACarrera("  ", Carrera.SOFTWARE),
                "Código blank debe retornar false");
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRUEBA 4: porCarreraParaTutor()
    // ─────────────────────────────────────────────────────────────────────────

    @Test
    @DisplayName("PRUEBA 4: porCarreraParaTutor() debe filtrar materias según semestre del tutor")
    void porCarreraParaTutor_deberiaFiltrarMateriasSegunSemestreDelTutor() {
        // Caso 1: carrera null → lista vacía
        List<MateriasCatalogo.Opcion> sinCarrera =
                MateriasCatalogo.porCarreraParaTutor(null, Semestre.TERCER_SEMESTRE);
        assertTrue(sinCarrera.isEmpty(),
                "Carrera null debe retornar lista vacía");

        // Caso 2: tutor en 2do semestre → solo puede dar materias de semestre < 2 (solo 1er sem)
        List<MateriasCatalogo.Opcion> materias2do =
                MateriasCatalogo.porCarreraParaTutor(Carrera.SOFTWARE, Semestre.SEGUNDO_SEMESTRE);
        assertFalse(materias2do.isEmpty(),
                "Debe haber materias de 1er semestre para un tutor de 2do");
        assertTrue(materias2do.stream().allMatch(o -> o.getSemestre() < 2),
                "Todas las materias deben ser de semestre < 2");

        // Caso 3: tutor en 9no semestre → más materias que tutor en 2do
        List<MateriasCatalogo.Opcion> materias9no =
                MateriasCatalogo.porCarreraParaTutor(Carrera.SOFTWARE, Semestre.NOVENO_SEMESTRE);
        assertTrue(materias9no.size() > materias2do.size(),
                "Tutor de 9no semestre debe poder dar más materias que tutor de 2do");

        // Caso 4: tutor en 1er semestre → no puede dar ninguna materia (nada es < 1)
        List<MateriasCatalogo.Opcion> materias1ro =
                MateriasCatalogo.porCarreraParaTutor(Carrera.SOFTWARE, Semestre.PRIMER_SEMESTRE);
        assertTrue(materias1ro.isEmpty(),
                "Tutor de 1er semestre no puede dar ninguna materia");
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRUEBA 5: codigoPermitidoParaTutor() — PARAMETRIZADA
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Fuente de datos para la prueba parametrizada.
     * Genera dinámicamente un código real de 1er semestre de SOFTWARE
     * para evitar hardcodear valores que podrían cambiar.
     */
    static Stream<Arguments> casosCodigoPermitido() {
        // Código real de semestre 1 de SOFTWARE (obtenido del catálogo)
        String codSem1 = MateriasCatalogo.porCarrera(Carrera.SOFTWARE)
                .stream()
                .filter(o -> o.getSemestre() == 1)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("No hay materias de semestre 1 en SOFTWARE"))
                .getCodigo();

        return Stream.of(
                // Caso 1: código de sem1, tutor en sem2 → PERMITIDO (sem1 < sem2)
                Arguments.of(Carrera.SOFTWARE, Semestre.SEGUNDO_SEMESTRE, codSem1, true),
                // Caso 2: código de sem1, tutor en sem1 → NO PERMITIDO (sem1 no es < sem1)
                Arguments.of(Carrera.SOFTWARE, Semestre.PRIMER_SEMESTRE, codSem1, false),
                // Caso 3: carrera null → false
                Arguments.of(null, Semestre.SEGUNDO_SEMESTRE, codSem1, false),
                // Caso 4: código null → false
                Arguments.of(Carrera.SOFTWARE, Semestre.SEGUNDO_SEMESTRE, null, false),
                // Caso 5: código inválido → false
                Arguments.of(Carrera.SOFTWARE, Semestre.SEGUNDO_SEMESTRE, "INVALIDO_999", false)
        );
    }

    @ParameterizedTest(name = "[{index}] carrera={0}, semestre={1}, codigo={2} → permitido={3}")
    @MethodSource("casosCodigoPermitido")
    @DisplayName("PRUEBA 5: codigoPermitidoParaTutor() — validación parametrizada")
    void codigoPermitidoParaTutor_casosMultiples(
            Carrera carrera, Semestre semestre, String codigo, boolean esperado) {

        assertEquals(esperado,
                MateriasCatalogo.codigoPermitidoParaTutor(carrera, semestre, codigo),
                "codigoPermitidoParaTutor(" + carrera + ", " + semestre + ", " + codigo
                        + ") debería ser " + esperado);
    }
}