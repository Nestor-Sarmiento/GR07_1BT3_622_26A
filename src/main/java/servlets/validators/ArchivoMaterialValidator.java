package servlets.validators;

import java.util.Set;

/**
 * Reglas de validación para nombres de archivo subidos como material (extensión permitida).
 */
public final class ArchivoMaterialValidator {

    private static final Set<String> EXTENSIONES_PERMITIDAS = Set.of(
            ".pdf", ".doc", ".docx", ".xls", ".xlsx", ".xlsm", ".csv", ".xml");

    private ArchivoMaterialValidator() {
    }

    public static boolean esExtensionPermitida(String extension) {
        if (extension == null || extension.isBlank()) {
            return false;
        }
        return EXTENSIONES_PERMITIDAS.contains(extension.toLowerCase());
    }

    public static String obtenerExtension(String nombreArchivo) {
        if (nombreArchivo == null) {
            return "";
        }
        int idx = nombreArchivo.lastIndexOf('.');
        return (idx != -1) ? nombreArchivo.substring(idx).toLowerCase() : "";
    }
}
