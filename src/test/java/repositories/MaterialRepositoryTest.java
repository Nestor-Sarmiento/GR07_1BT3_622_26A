package repositories;

import Enums.EstadoMaterial;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import schemas.Material;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

class MaterialRepositoryTest {

    // ─── Test Unitario 1: Validación básica de campos de Material ──────────────

    @Test
    void materialBuilder_deberiaCrearObjetoConDatosCompletos() {
        // Arrange
        String titulo = "Guía de Macroeconomía";
        String nombreMateria = "Macroeconomía I";
        String usuario = "Antonela";
        EstadoMaterial estado = EstadoMaterial.PENDIENTE;
        LocalDateTime fecha = LocalDateTime.now();

        // Act
        Material material = Material.builder()
                .titulo(titulo)
                .nombreMateria(nombreMateria)
                .usuario(usuario)
                .estado(estado)
                .fechaEnvio(fecha)
                .rutaArchivo("/uploads/test.pdf")
                .tipoArchivo("pdf")
                .build();

        // Assert
        assertEquals(titulo, material.getTitulo());
        assertEquals(nombreMateria, material.getNombreMateria());
        assertEquals(usuario, material.getUsuario());
        assertEquals(estado, material.getEstado());
        assertEquals(fecha, material.getFechaEnvio());
        assertEquals("/uploads/test.pdf", material.getRutaArchivo());
        assertEquals("pdf", material.getTipoArchivo());
    }

    // ─── Test Parametrizado 2: Validación de usuarios diferentes ───────────────

    @ParameterizedTest(name = "usuario={0} → title={1} → estado={2}")
    @CsvSource({
            "Antonela,    Guía Básica,            PENDIENTE",
            "Carlos,      Taller Avanzado,        APROBADO",
            "María López, Material Complementario, RECHAZADO",
            "Prof_Juan,   Tutorial Interactivo,   PENDIENTE"
    })
    void materialBuilder_deberiaFuncionarConDiferentesUsuarios(
            String usuario, String titulo, EstadoMaterial estado) {

        // Act
        Material material = Material.builder()
                .usuario(usuario)
                .titulo(titulo)
                .estado(estado)
                .nombreMateria("Asignatura Test")
                .fechaEnvio(LocalDateTime.now())
                .build();

        // Assert
        assertEquals(usuario, material.getUsuario());
        assertEquals(titulo, material.getTitulo());
        assertEquals(estado, material.getEstado());
        assertNotNull(material.getTitulo());
        assertTrue(material.getTitulo().length() > 0);
    }
}


