package repositories;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public final class JpaUtil {
    private static final Map<String, String> DOTENV = loadDotenv();
    private static final EntityManagerFactory EMF = Persistence.createEntityManagerFactory("pdciaePU",
            buildOverrides());

    private JpaUtil() {
    }

    private static Map<String, Object> buildOverrides() {
        Map<String, Object> overrides = new LinkedHashMap<>();

        String dbUrl = firstNonBlank(env("DB_URL"), env("DATABASE_URL"), env("JDBC_DATABASE_URL"));
        if (!dbUrl.isBlank()) {
            overrides.put("jakarta.persistence.jdbc.driver", firstNonBlank(env("DB_DRIVER"), "org.postgresql.Driver"));
            overrides.put("jakarta.persistence.jdbc.url", dbUrl);

            String dbUser = firstNonBlank(env("DB_USER"), env("DATABASE_USER"));
            if (!dbUser.isBlank()) {
                overrides.put("jakarta.persistence.jdbc.user", dbUser);
            }

            String dbPassword = firstNonBlank(env("DB_PASSWORD"), env("DATABASE_PASSWORD"));
            if (!dbPassword.isBlank()) {
                overrides.put("jakarta.persistence.jdbc.password", dbPassword);
            }

            overrides.put("hibernate.dialect", firstNonBlank(env("HIBERNATE_DIALECT"), "org.hibernate.dialect.PostgreSQLDialect"));
        }

        String ddlAuto = env("HIBERNATE_HBM2DDL_AUTO");
        if (!ddlAuto.isBlank()) {
            overrides.put("hibernate.hbm2ddl.auto", ddlAuto);
        }

        String showSql = env("HIBERNATE_SHOW_SQL");
        if (!showSql.isBlank()) {
            overrides.put("hibernate.show_sql", showSql);
        }

        return overrides;
    }

    private static String env(String key) {
        String fromDotenv = DOTENV.get(key);
        if (fromDotenv != null && !fromDotenv.isBlank()) {
            return fromDotenv.trim();
        }

        String fromSystem = System.getenv(key);
        return fromSystem == null ? "" : fromSystem.trim();
    }

    private static Map<String, String> loadDotenv() {
        Map<String, String> values = new HashMap<>();
        Path path = Path.of(".env");
        if (!Files.exists(path)) {
            return values;
        }

        try {
            for (String line : Files.readAllLines(path, StandardCharsets.UTF_8)) {
                String trimmed = line.trim();
                if (trimmed.startsWith("#") || !trimmed.contains("=")) {
                    continue;
                }

                int equalsIndex = trimmed.indexOf('=');
                String key = trimmed.substring(0, equalsIndex).trim();
                String value = trimmed.substring(equalsIndex + 1).trim();

                if ((value.startsWith("\"") && value.endsWith("\""))
                        || (value.startsWith("'") && value.endsWith("'"))) {
                    value = value.substring(1, value.length() - 1);
                }

                if (!key.isBlank()) {
                    values.put(key, value);
                }
            }
        } catch (IOException ignored) {
            // Fall back to system environment variables only.
        }

        return values;
    }

    private static String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value.trim();
            }
        }
        return "";
    }

    public static String getConfigValue(String key) {
        return env(key);
    }

    public static String getConfigValue(String key, String defaultValue) {
        String value = env(key);
        return value.isBlank() ? defaultValue : value;
    }

    public static EntityManager createEntityManager() {
        return EMF.createEntityManager();
    }

    public static void shutdown() {
        if (EMF.isOpen()) {
            EMF.close();
        }
    }
}

