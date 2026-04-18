package repositories;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.logging.Logger;

public final class JpaUtil {
    private static final Logger LOGGER = Logger.getLogger(JpaUtil.class.getName());
    private static final Map<String, String> DOTENV = loadDotenv();
    private static volatile EntityManagerFactory emf;

    private JpaUtil() {
    }

    private static Map<String, Object> buildOverrides() {
        Map<String, Object> overrides = new LinkedHashMap<>();

        String dbUrl = firstNonBlank(env("DB_URL"), env("DATABASE_URL"), env("JDBC_DATABASE_URL"));
        if (!dbUrl.isBlank()) {
            overrides.put("jakarta.persistence.jdbc.driver",
                    firstNonBlank(env("DB_DRIVER"), "org.postgresql.Driver"));
            overrides.put("jakarta.persistence.jdbc.url", dbUrl);

            String dbUser = firstNonBlank(env("DB_USER"), env("DATABASE_USER"));
            if (!dbUser.isBlank()) {
                overrides.put("jakarta.persistence.jdbc.user", dbUser);
            }

            String dbPassword = firstNonBlank(env("DB_PASSWORD"), env("DATABASE_PASSWORD"));
            if (!dbPassword.isBlank()) {
                overrides.put("jakarta.persistence.jdbc.password", dbPassword);
            }

            overrides.put("hibernate.dialect",
                    firstNonBlank(env("HIBERNATE_DIALECT"), "org.hibernate.dialect.PostgreSQLDialect"));
            LOGGER.info("JPA configurado con base externa: " + safeDbUrl(dbUrl));
        } else {
            LOGGER.warning("No se encontró DB_URL/DATABASE_URL. Se usará la configuración por defecto de persistence.xml.");
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
        Map<String, String> values = new LinkedHashMap<>();
        Path path = findDotenvPath();
        if (path == null || !Files.exists(path)) {
            return values;
        }

        try {
            for (String line : Files.readAllLines(path, StandardCharsets.UTF_8)) {
                String trimmed = line.trim();
                if (trimmed.isBlank() || trimmed.startsWith("#") || !trimmed.contains("=")) {
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

    private static Path findDotenvPath() {
        List<Path> candidates = new ArrayList<>();

        addIfPresent(candidates, systemPath("user.dir"));
        addIfPresent(candidates, systemPath("catalina.base"));
        addIfPresent(candidates, systemPath("catalina.home"));
        addIfPresent(candidates, classLocationPath());

        for (Path candidate : candidates) {
            Path current = candidate;
            for (int i = 0; i < 6 && current != null; i++) {
                Path dotenv = current.resolve(".env");
                if (Files.exists(dotenv)) {
                    return dotenv;
                }
                current = current.getParent();
            }
        }

        return Path.of(".env");
    }

    private static void addIfPresent(List<Path> candidates, Path path) {
        if (path != null) {
            candidates.add(path);
        }
    }

    private static Path systemPath(String key) {
        String value = System.getProperty(key);
        if (value == null || value.isBlank()) {
            return null;
        }
        return Path.of(value);
    }

    private static Path classLocationPath() {
        try {
            return Path.of(Objects.requireNonNull(JpaUtil.class.getProtectionDomain().getCodeSource()).getLocation().toURI())
                    .getParent();
        } catch (URISyntaxException | NullPointerException ex) {
            return null;
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
