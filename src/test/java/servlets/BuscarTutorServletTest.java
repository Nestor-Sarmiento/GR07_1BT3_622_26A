package servlets;

import Enums.MateriaFIS;
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
                .materiasRelacionadas(Set.of(MateriaFIS.PROGRAMACION_I, MateriaFIS.SISTEMAS_OPERATIVOS))
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
                .materiasRelacionadas(Set.of())
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
    // PRUEBA 5: Validación parametrizada de múltiples materias
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Prueba parametrizada que verifica que MateriaFIS.valueOf() reconoce
     * las materias válidas del enum y rechaza las inválidas con
     * IllegalArgumentException.
     *
     * Cubre:
     *  - 3 materias existentes en el enum → esValida=true
     *  - 1 nombre que NO existe           → esValida=false
     *  - PROGRAMACION_II que sí existe    → esValida=true
     */
    @ParameterizedTest(name = "materia={0} → válida={1}")
    @CsvSource({
            "PROGRAMACION_I,      true",
            "ALGEBRA_LINEAL,      true",
            "SISTEMAS_OPERATIVOS, true",
            "MATERIA_INVALIDA,    false",
            "PROGRAMACION_II,     true"
    })
    @DisplayName("PRUEBA 5: Validación parametrizada de múltiples materias")
    void validarMultiplesMaterias(String materiaNombre, boolean esValida) {
        // Act
        boolean estaValida = true;
        try {
            MateriaFIS.valueOf(materiaNombre.trim());
        } catch (IllegalArgumentException e) {
            estaValida = false;
        }

        // Assert
        if (esValida) {
            assertTrue(estaValida,
                    "'" + materiaNombre + "' debería existir en MateriaFIS");
        } else {
            assertFalse(estaValida,
                    "'" + materiaNombre + "' NO debería existir en MateriaFIS");
        }
    }

}