package servlets;

import Enums.MateriasCatalogo;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import schemas.Tutor;
import schemas.TutorListadoDTO;
import schemas.TutorListadoMapper;

import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

/**
 * BuscarTutorServletTest
 * Contiene Pruebas 1, 2, 3 y 5
 */
@DisplayName("BuscarTutorServlet - Pruebas Unitarias")
class BuscarTutorServletTest {

    // ─────────────────────────────────────────────────────────────────────────
    // PRUEBA 1: Conversión Tutor → TutorListadoDTO
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Valida que toDto() mapea correctamente todos los campos del Tutor al DTO:
     * id, nombre completo, biografía truncada y etiquetas de materias.
     */
    @Test
    @DisplayName("PRUEBA 1: Conversión Tutor → TutorListadoDTO")
    void toDto_deberiaConvertirTutorCompleto() {
        // Arrange - Tutor con todos los campos y bio > 140 chars
        Tutor tutor = Tutor.builder()
                .id(1L)
                .nombre("Carlos")
                .segundoNombre("Miguel")
                .apellido("López")
                .segundoApellido("González")
                .descripcionProfesional("Experto en Programación" + "X".repeat(130))
                .codigosMateriaRelacionadas(Set.of("ICCD144", "ICCD323"))
                .build();

        // Act
        TutorListadoDTO dto = TutorListadoMapper.toDto(tutor);

        // Assert
        assertEquals(1L, dto.getIdTutor(),
                "El id debe ser 1");
        assertEquals("Carlos Miguel López González", dto.getNombreMostrar(),
                "El nombre completo debe concatenarse en orden");
        assertTrue(dto.getBioCorta().length() <= 140,
                "La bio no puede superar 140 caracteres");
        // La clase TutorListadoDTO usa el campo materiasEtiquetas → getter getMateriasEtiquetas()
        assertEquals(2, dto.getMateriasEtiquetas().size(),
                "Deben mapearse las 2 materias del tutor");
        assertTrue(dto.getMateriasEtiquetas().contains("PROGRAMACIÓN I"));
        assertTrue(dto.getMateriasEtiquetas().contains("SISTEMAS OPERATIVOS"));
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRUEBA 2: Construcción de nombre completo
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Valida que joinNombreParts() maneja correctamente nulls, strings vacíos
     * y espacios extra, produciendo siempre una salida limpia.
     */
    @Test
    @DisplayName("PRUEBA 2: Construcción de nombre completo")
    void joinNombreParts_deberiaUnirPartesCorrectamente() {
        // Act - cuatro combinaciones distintas
        String resultado1 = TutorListadoMapper.joinNombreParts("Juan", "Carlos", "Pérez", "López");
        String resultado2 = TutorListadoMapper.joinNombreParts("María", null, "García", "");
        String resultado3 = TutorListadoMapper.joinNombreParts(null, null, null, null);
        String resultado4 = TutorListadoMapper.joinNombreParts("  Ana María  ", "   ", "Rodríguez");

        // Assert
        assertEquals("Juan Carlos Pérez López", resultado1,
                "Partes válidas deben unirse con un espacio");
        assertEquals("María García", resultado2,
                "Nulls y vacíos deben ignorarse");
        assertEquals("", resultado3,
                "Todo null debe retornar cadena vacía");
        assertEquals("Ana María Rodríguez", resultado4,
                "Los espacios extra deben recortarse");
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRUEBA 3: Truncamiento de biografía a 140 caracteres
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Valida que toDto() trunca la bio a exactamente 140 caracteres y añade "…"
     * cuando la descripción profesional supera ese límite.
     */
    @Test
    @DisplayName("PRUEBA 3: Truncamiento de biografía a 140 caracteres")
    void toDto_deberiaTruncarBiografiaA140Caracteres() {
        // Arrange - bio de 150 'A'
        String bioOriginal = "A".repeat(150);
        Tutor tutor = Tutor.builder()
                .id(1L)
                .nombre("Profesor")
                .descripcionProfesional(bioOriginal)
                .codigosMateriaRelacionadas(Set.of())
                .build();

        // Act
        TutorListadoDTO dto = TutorListadoMapper.toDto(tutor);

        // Assert
        // La lógica en TutorListadoMapper hace: bio.substring(0, BIO_MAX-1) + "…"
        // → 139 chars de 'A' + "…" = 140 chars totales
        assertEquals(140, dto.getBioCorta().length(),
                "La bio truncada debe tener exactamente 140 caracteres");
        assertTrue(dto.getBioCorta().endsWith("…"),
                "La bio truncada debe terminar con '…'");
        assertTrue(dto.getBioCorta().startsWith("A"),
                "La bio truncada debe conservar el inicio del texto original");
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRUEBA 5: Validación parametrizada de códigos SIGLA en el catálogo
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Prueba parametrizada que verifica que {@link MateriasCatalogo#buscarPorCodigo(String)}
     * reconoce códigos válidos y rechaza los que no existen.
     */
    @ParameterizedTest(name = "codigo={0} → válido={1}")
    @CsvSource({
            "ICCD144,              true",
            "MATD113,              true",
            "ICCD323,              true",
            "CODIGO_INVALIDO_XXX,  false",
            "ICCD244,              true"
    })
    @DisplayName("PRUEBA 5: Validación parametrizada de códigos de materia")
    void validarMultiplesCodigosMateria(String codigo, boolean esValida) {
        boolean estaValida = MateriasCatalogo.buscarPorCodigo(codigo.trim()).isPresent();

        if (esValida) {
            assertTrue(estaValida,
                    "'" + codigo + "' debería existir en el catálogo de materias");
        } else {
            assertFalse(estaValida,
                    "'" + codigo + "' NO debería existir en el catálogo de materias");
        }
    }

}
