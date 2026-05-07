package repositories;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Logger;

public final class JpaUtil {
    private static final Logger LOGGER = Logger.getLogger(JpaUtil.class.getName());
    private static volatile EntityManagerFactory emf;

    private JpaUtil() {
    }

    private static Map<String, Object> buildOverrides() {
        Map<String, Object> overrides = new LinkedHashMap<>();

        // Configuración quemada (anteriormente en .env)
        String dbUrl = "jdbc:postgresql://aws-1-us-west-2.pooler.supabase.com:5432/postgres?sslmode=require";
        String dbUser = "postgres.yszzewnynkvmkeygvksh";
        String dbPassword = "owlshare2026";
        String dbDriver = "org.postgresql.Driver";
        String hibernateDialect = "org.hibernate.dialect.PostgreSQLDialect";
        String hbm2ddlAuto = "update";
        String showSql = "true";

        overrides.put("jakarta.persistence.jdbc.driver", dbDriver);
        overrides.put("jakarta.persistence.jdbc.url", dbUrl);
        overrides.put("jakarta.persistence.jdbc.user", dbUser);
        overrides.put("jakarta.persistence.jdbc.password", dbPassword);
        overrides.put("hibernate.dialect", hibernateDialect);
        overrides.put("hibernate.hbm2ddl.auto", hbm2ddlAuto);
        overrides.put("hibernate.show_sql", showSql);

        LOGGER.info("JPA configurado con credenciales internas (hardcoded).");

        return overrides;
    }

    private static String env(String key) {
        // Mapeo de claves para mantener compatibilidad con métodos existentes
        switch (key) {
            case "DB_URL": return "jdbc:postgresql://aws-1-us-west-2.pooler.supabase.com:5432/postgres?sslmode=require";
            case "DB_USER": return "postgres.yszzewnynkvmkeygvksh";
            case "DB_PASSWORD": return "owlshare2026";
            case "DB_DRIVER": return "org.postgresql.Driver";
            case "HIBERNATE_DIALECT": return "org.hibernate.dialect.PostgreSQLDialect";
            case "HIBERNATE_HBM2DDL_AUTO": return "update";
            case "HIBERNATE_SHOW_SQL": return "true";
            case "ADMIN_EMAIL": return "admin@olwshare.com";
            case "ADMIN_PASSWORD": return "OlwShare2026!";
            case "ADMIN_NOMBRE": return "Administrador";
            case "ADMIN_APELLIDO": return "Sistema";
            default:
                String fromSystem = System.getenv(key);
                return fromSystem == null ? "" : fromSystem.trim();
        }
    }

    private static String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value.trim();
            }
        }
        return "";
    }

    private static String safeDbUrl(String dbUrl) {
        int paramsIndex = dbUrl.indexOf('?');
        return paramsIndex >= 0 ? dbUrl.substring(0, paramsIndex) : dbUrl;
    }

    public static String getConfigValue(String key) {
        return env(key);
    }

    public static String getConfigValue(String key, String defaultValue) {
        String value = env(key);
        return value.isBlank() ? defaultValue : value;
    }

    public static EntityManager createEntityManager() {
        return getEntityManagerFactory().createEntityManager();
    }

    public static void shutdown() {
        EntityManagerFactory local = emf;
        if (local != null && local.isOpen()) {
            local.close();
        }
    }

    private static EntityManagerFactory getEntityManagerFactory() {
        EntityManagerFactory local = emf;
        if (local != null) {
            return local;
        }

        synchronized (JpaUtil.class) {
            local = emf;
            if (local == null) {
                local = Persistence.createEntityManagerFactory("pdciaePU", buildOverrides());
                emf = local;
            }
        }

        return local;
    }
}
