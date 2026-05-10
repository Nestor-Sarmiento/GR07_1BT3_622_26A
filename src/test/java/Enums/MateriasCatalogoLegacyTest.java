package Enums;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class MateriasCatalogoLegacyTest {

    @Test
    void mapeaConstantesAntiguasASiglas() {
        assertEquals("ICCD244", MateriasCatalogo.codigoPorNombreConstanteLegacy("PROGRAMACION_II").orElseThrow());
        assertEquals("CSHD211",
                MateriasCatalogo.codigoPorNombreConstanteLegacy("ANALISIS_SOCIOECONOMICO_Y_POLITICO_DEL_ECUADOR")
                        .orElseThrow());
        assertEquals("ISWD453",
                MateriasCatalogo.codigoPorNombreConstanteLegacy("FUNDAMENTOS_DE_BASES_DE_DATOS").orElseThrow());
    }

    @Test
    void desconocidoVacio() {
        assertTrue(MateriasCatalogo.codigoPorNombreConstanteLegacy("NO_EXISTE").isEmpty());
    }
}
