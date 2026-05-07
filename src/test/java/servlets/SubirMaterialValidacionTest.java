package servlets;

import org.junit.jupiter.api.Test;
import servlets.validators.ArchivoMaterialValidator;

import static org.junit.jupiter.api.Assertions.*;

public class SubirMaterialValidacionTest {

    @Test
    void testExtensionPermitida() {
        // Escenario 1: Archivo válido según los requerimientos
        String extensionPdf = ArchivoMaterialValidator.obtenerExtension("documento.pdf");
        assertTrue(ArchivoMaterialValidator.esExtensionPermitida(extensionPdf),
            "La extensión .pdf debería ser permitida");

        String extensionDocx = ArchivoMaterialValidator.obtenerExtension("tarea.docx");
        assertTrue(ArchivoMaterialValidator.esExtensionPermitida(extensionDocx),
            "La extensión .docx debería ser permitida");
    }

    @Test
    void testExtensionNoPermitidaOArchivoVacio() {
        // Escenario 2: Dado que no ha seleccionado ningún archivo o es inválido
        // Un archivo sin nombre o vacío resultará en extensión vacía
        String extensionVacia = ArchivoMaterialValidator.obtenerExtension("");
        assertFalse(ArchivoMaterialValidator.esExtensionPermitida(extensionVacia),
            "Un archivo sin extensión no debería ser permitido");

        String extensionExe = ArchivoMaterialValidator.obtenerExtension("virus.exe");
        assertFalse(ArchivoMaterialValidator.esExtensionPermitida(extensionExe),
            "La extensión .exe no debería estar en la lista de permitidas");
    }
}

