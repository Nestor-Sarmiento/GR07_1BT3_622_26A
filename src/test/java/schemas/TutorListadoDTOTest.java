package schemas;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;

/**
 * TutorListadoDTOTest
 * Prueba 4: Test Unitario Normal - Validación de Inicial de TutorListadoDTO
 *
 * Objetivo: Validar que el método getInicial() retorna la primera letra en mayúscula
 * o "?" si el nombre es vacío/null.
 */
@DisplayName("TutorListadoDTO - Prueba de Inicial")
class TutorListadoDTOTest {

    /**
     * PRUEBA 4: Test Unitario Normal - Validación de Inicial
     *
     * Valida que el método getInicial() retorna:
     * - La primera letra en mayúscula para nombres válidos
     * - "?" para nombres vacíos o null
     */
    @Test
    @DisplayName("getInicial() debería retornar primera letra en mayúscula o '?' si es vacío/null")
    void getInicial_deberiaRetornarPrimeraLetraMayuscula() {
        // Arrange - Crear 3 DTOs con diferentes nombres
        TutorListadoDTO dto1 = TutorListadoDTO.builder()
                .nombreMostrar("carlos López")
                .bioCorta("Tutor de programación")
                .materiasEtiquetas(new ArrayList<>())
                .build();

        TutorListadoDTO dto2 = TutorListadoDTO.builder()
                .nombreMostrar("  ")  // Solo espacios en blanco
                .bioCorta("Tutor")
                .materiasEtiquetas(new ArrayList<>())
                .build();

        TutorListadoDTO dto3 = TutorListadoDTO.builder()
                .nombreMostrar(null)  // null
                .bioCorta("Tutor")
                .materiasEtiquetas(new ArrayList<>())
                .build();

        // Act & Assert - Validaciones
        // Caso 1: Nombre válido debería retornar "C"
        assertEquals("C", dto1.getInicial(),
                "Para 'carlos López' debería retornar 'C'");

        // Caso 2: Espacios en blanco debería retornar "?"
        assertEquals("?", dto2.getInicial(),
                "Para espacios en blanco debería retornar '?'");

        // Caso 3: null debería retornar "?"
        assertEquals("?", dto3.getInicial(),
                "Para null debería retornar '?'");
    }

    /**
     * Test adicional: Validar inicial con diferentes primeras letras
     */
    @Test
    @DisplayName("getInicial() debería funcionar con diferentes primeras letras")
    void getInicial_deberiaFuncionarConDiferentesLetras() {
        // Arrange
        String[] nombres = {"Ana", "Beatriz", "carlos", "Daniel", "Estefanía"};
        String[] inicialesEsperadas = {"A", "B", "C", "D", "E"};

        // Act & Assert
        for (int i = 0; i < nombres.length; i++) {
            TutorListadoDTO dto = TutorListadoDTO.builder()
                    .nombreMostrar(nombres[i])
                    .build();

            assertEquals(inicialesEsperadas[i], dto.getInicial(),
                    "Para '" + nombres[i] + "' debería retornar '" + inicialesEsperadas[i] + "'");
        }
    }
}