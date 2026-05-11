package Enums;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * SemestreTest
 * PRUEBA 1: Test Unitario Normal — Validación de getNumero() en Semestre
 *
 * Objetivo: Verificar que el ordinal académico (1–9) se calcula correctamente
 * a partir del ordinal del enum (0-based → 1-based).
 */
@DisplayName("Semestre - Prueba de número académico")
class SemestreTest {

    @Test
    @DisplayName("PRUEBA 1A: getNumero() debe retornar el ordinal académico correcto")
    void getNumero_deberiaRetornarNumeroAcademicoCorrect() {
        // Assert - extremos y punto medio
        assertEquals(1, Semestre.PRIMER_SEMESTRE.getNumero(),
                "PRIMER_SEMESTRE debe ser 1");
        assertEquals(5, Semestre.QUINTO_SEMESTRE.getNumero(),
                "QUINTO_SEMESTRE debe ser 5");
        assertEquals(9, Semestre.NOVENO_SEMESTRE.getNumero(),
                "NOVENO_SEMESTRE debe ser 9");
    }

    @Test
    @DisplayName("PRUEBA 1B: getNumero() debe ser consistente con ordinal() + 1")
    void getNumero_deberiaSerConsistenteConOrdinal() {
        // Verificar que todos los semestres siguen la fórmula ordinal + 1
        for (Semestre s : Semestre.values()) {
            assertEquals(s.ordinal() + 1, s.getNumero(),
                    "getNumero() de " + s.name() + " debe ser ordinal + 1");
        }
    }

    @Test
    @DisplayName("PRUEBA 1C: getNombre() debe retornar la descripción no vacía")
    void getNombre_deberiaRetornarDescripcionNoVacia() {
        for (Semestre s : Semestre.values()) {
            assertNotNull(s.getNombre(),
                    "getNombre() de " + s.name() + " no debe ser null");
            assertFalse(s.getNombre().isBlank(),
                    "getNombre() de " + s.name() + " no debe estar vacío");
        }
        assertEquals("Quinto semestre", Semestre.QUINTO_SEMESTRE.getNombre());
    }
}