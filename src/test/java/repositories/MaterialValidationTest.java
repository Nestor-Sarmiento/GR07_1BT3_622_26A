package repositories;

import Enums.EstadoMaterial;
import org.junit.jupiter.api.Test;
import schemas.Material;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

/**
 * MaterialValidationTest
 * 2 Pruebas unitarias normales para validar Material
 */
class MaterialValidationTest {

    // ─── Test Unitario 3: Validar campos opcionales en null ─────────────────────

    @Test
    void materialBuilder_deberiaPermitirCamposOpcionalesEnNull() {
        // Arrange
        Material material = Material.builder()
                .titulo("Material Sin Detalles")
                .estado(EstadoMaterial.PENDIENTE)
                .usuario("tutor123")
                .build();

        // Act & Assert
        assertEquals("Material Sin Detalles", material.getTitulo());
        assertEquals(EstadoMaterial.PENDIENTE, material.getEstado());
        assertEquals("tutor123", material.getUsuario());
        assertNull(material.getDescripcion());
        assertNull(material.getNombreMateria());
        assertNull(material.getRutaArchivo());
        assertNull(material.getTipoArchivo());
        assertNull(material.getCosto());
        assertNull(material.getFechaEnvio());
        assertNull(material.getId());
    }

    // ─── Test Unitario 4: Validar cambio de estado de material ──────────────────

    @Test
    void materialBuilder_deberiaActualizarEstadoCorrectamente() {
        // Arrange
        LocalDateTime ahora = LocalDateTime.now();
        Material material = Material.builder()
                .id(1L)
                .titulo("Guía Completa")
                .nombreMateria("Matemáticas")
                .usuario("profesor1")
                .estado(EstadoMaterial.PENDIENTE)
                .fechaEnvio(ahora)
                .rutaArchivo("/uploads/material.pdf")
                .tipoArchivo("pdf")
                .build();

        // Act - Simular cambio de estado (como lo haría el servlet MaterialDetalleServlet)
        material.setEstado(EstadoMaterial.APROBADO);

        // Assert
        assertNotNull(material.getId());
        assertEquals(1L, material.getId());
        assertEquals("Guía Completa", material.getTitulo());
        assertEquals("Matemáticas", material.getNombreMateria());
        assertEquals("profesor1", material.getUsuario());
        assertEquals(EstadoMaterial.APROBADO, material.getEstado());
        assertEquals(ahora, material.getFechaEnvio());
        assertEquals("/uploads/material.pdf", material.getRutaArchivo());
        assertEquals("pdf", material.getTipoArchivo());
    }
}

