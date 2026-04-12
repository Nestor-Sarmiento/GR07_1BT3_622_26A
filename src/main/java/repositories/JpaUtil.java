package repositories;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

public final class JpaUtil {
    private static final Logger LOGGER = Logger.getLogger(JpaUtil.class.getName());
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
            LOGGER.info("JPA configurado con base externa: " + safeDbUrl(dbUrl));
        } else {
            LOGGER.warning("No se encontro DB_URL/DATABASE_URL. Se usara la configuracion por defecto de persistence.xml.");
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
        Path path = findDotenvPath();
        if (!Files.exists(path)) {
            LOGGER.info("No se encontro archivo .env en rutas candidatas.");
            return values;
        }

        try {
            LOGGER.info("Cargando variables desde .env: " + path.toAbsolutePath());
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

    private static Path findDotenvPath() {
        List<Path> seeds = new ArrayList<>();
        seeds.add(Path.of("").toAbsolutePath());

        addIfPresent(seeds, systemPath("user.dir"));
        addIfPresent(seeds, systemPath("catalina.base"));
        addIfPresent(seeds, classLocationPath());

        for (Path seed : seeds) {
            Path current = seed;
            for (int i = 0; i < 20 && current != null; i++) {
                Path candidate = current.resolve(".env");
                if (Files.exists(candidate)) {
                    return candidate;
                }
                current = current.getParent();
            }
        }

        return Path.of(".env").toAbsolutePath();
    }

    private static Path systemPath(String key) {
        String value = System.getProperty(key);
        if (value == null || value.isBlank()) {
            return null;
        }
        return Paths.get(value).toAbsolutePath();
    }

    private static Path classLocationPath() {
        try {
            return Paths.get(JpaUtil.class.getProtectionDomain().getCodeSource().getLocation().toURI()).toAbsolutePath();
        } catch (URISyntaxException | NullPointerException ex) {
            return null;
        }
    }

    private static void addIfPresent(List<Path> seeds, Path candidate) {
        if (candidate != null && !seeds.contains(candidate)) {
            seeds.add(candidate);
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
        return EMF.createEntityManager();
    }

    public static void shutdown() {
        if (EMF.isOpen()) {
            EMF.close();
        }
    }
}

