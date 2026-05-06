package servlets;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class SubirMaterialValidacionTest {

    @Test
    void testExtensionPermitida() {
        // Escenario 1: Archivo válido según los requerimientos
        String extensionPdf = SubirMaterialServlet.obtenerExtension("documento.pdf");
        assertTrue(SubirMaterialServlet.esExtensionPermitida(extensionPdf),
            "La extensión .pdf debería ser permitida");

        String extensionDocx = SubirMaterialServlet.obtenerExtension("tarea.docx");
        assertTrue(SubirMaterialServlet.esExtensionPermitida(extensionDocx),
            "La extensión .docx debería ser permitida");
    }

    @Test
    void testExtensionNoPermitidaOArchivoVacio() {
        // Escenario 2: Dado que no ha seleccionado ningún archivo o es inválido
        // Un archivo sin nombre o vacío resultará en extensión vacía
        String extensionVacia = SubirMaterialServlet.obtenerExtension("");
        assertFalse(SubirMaterialServlet.esExtensionPermitida(extensionVacia),
            "Un archivo sin extensión no debería ser permitido");

        String extensionExe = SubirMaterialServlet.obtenerExtension("virus.exe");
        assertFalse(SubirMaterialServlet.esExtensionPermitida(extensionExe),
            "La extensión .exe no debería estar en la lista de permitidas");
    }
}

