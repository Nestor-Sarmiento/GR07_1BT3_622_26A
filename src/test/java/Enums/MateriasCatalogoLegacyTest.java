package Enums;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
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

    @Test
    void tutorQuintoSoloMateriasHastaCuartoSemestre() {
        var ops = MateriasCatalogo.porCarreraParaTutor(Carrera.SOFTWARE, Semestre.QUINTO_SEMESTRE);
        assertTrue(ops.stream().allMatch(o -> o.getSemestre() < 5));
        assertTrue(ops.stream().anyMatch(o -> o.getSemestre() == 4));
        assertTrue(ops.stream().noneMatch(o -> o.getSemestre() >= 5));
    }

    @Test
    void tutorPrimerSemestreSinMateriasEnCatalogo() {
        assertTrue(MateriasCatalogo.porCarreraParaTutor(Carrera.SOFTWARE, Semestre.PRIMER_SEMESTRE).isEmpty());
    }

    @Test
    void codigoPermitidoParaTutorRespetaTope() {
        assertTrue(MateriasCatalogo.codigoPermitidoParaTutor(Carrera.SOFTWARE, Semestre.SEXTO_SEMESTRE, "ICCD244"));
        assertFalse(MateriasCatalogo.codigoPermitidoParaTutor(Carrera.SOFTWARE, Semestre.SEGUNDO_SEMESTRE, "ISWD523"));
    }
}
