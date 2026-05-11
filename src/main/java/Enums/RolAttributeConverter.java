package Enums;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

import java.util.Locale;

/**
 * El esquema PostgreSQL legado guarda a veces {@code Usuario} en lugar de {@code ESTUDIANTE}.
 */
@Converter
public class RolAttributeConverter implements AttributeConverter<Rol, String> {

    @Override
    public String convertToDatabaseColumn(Rol attribute) {
        return attribute == null ? null : attribute.name();
    }

    @Override
    public Rol convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isBlank()) {
            return null;
        }
        String u = dbData.trim().toUpperCase(Locale.ROOT);
        return switch (u) {
            case "USUARIO", "USER" -> Rol.ESTUDIANTE;
            case "ESTUDIANTE" -> Rol.ESTUDIANTE;
            case "TUTOR" -> Rol.TUTOR;
            case "ADMIN", "ADMINISTRADOR" -> Rol.ADMIN;
            default -> Rol.valueOf(u);
        };
    }
}
